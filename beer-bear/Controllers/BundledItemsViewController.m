//
//  BundledItemsViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/10/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "BundledItemsViewController.h"
#import "MZFormSheetController.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "SWTableViewCell.h"

#import "MappingProvider.h"

#import "Household.h"
#import "Bundle.h"
#import "Widget.h"

#import "WidgetViewController.h"

@interface BundledItemsViewController ()
  @property (nonatomic, strong) NSArray *bundles;
@end

@implementation BundledItemsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
  [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
  
  self.title = @"Stores & Widgets";
  
  self.bundles = @[];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWidgetSave:) name:@"widgetSaved" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWidgetSave:) name:@"refreshBundles" object:nil];
  if (![self isRegistered]) {
    [self showRegistration];
  } else {
    [self loadBundles];
  }
  
}

-(bool)isRegistered
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  int current_user = [preferences integerForKey:@"user_id"];
  return current_user > 0;
}

-(void)showRegistration
{
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"registration"];
  NSAssert(vc != nil, @"unable to find registration view");
  [self presentFormSheetWithViewController:vc animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

-(void)handleWidgetSave:(NSNotification *)notification
{
  [self loadBundles];
}

- (IBAction)pullRefresh
{
  [self loadBundles];
  
}

-(void)loadBundles
{
  [SVProgressHUD show];
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider bundleMapping];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/households/" stringByAppendingFormat:@"%ld/bundles", (long)[preferences integerForKey:@"household_id"]];
  
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  NSURL *url = [NSURL URLWithString:[@"http://wolverine.kolekti-api.c66.me" stringByAppendingString:pathPattern]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                      responseDescriptors:@[responseDescriptor]];
  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    self.bundles = mappingResult.array;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    NSLog(@"ERROR: %@", error);
    NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
    [SVProgressHUD showErrorWithStatus:@"Request failed"];
  }];
  
  [SVProgressHUD show];
  [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bundles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  Bundle *bundle = [self.bundles objectAtIndex:section];
  return bundle.widgets.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
//  Household *category = [self.households objectAtIndex:section];
  Bundle *bundle = [self.bundles objectAtIndex:section];
  
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
  view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
  label.text = bundle.name;
  label.font = [UIFont systemFontOfSize:18];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  [label sizeToFit];
  
  [view addSubview:label];
  
  if ([bundle.budget integerValue] > 0) {
    UILabel *budget = [[UILabel alloc] initWithFrame:CGRectMake(250, 4, 100, 0)];
    budget.text = [NSNumberFormatter localizedStringFromNumber:bundle.budget
                                                   numberStyle:NSNumberFormatterCurrencyStyle];
    budget.font = [UIFont systemFontOfSize:14];
    budget.textColor = [UIColor whiteColor];
    budget.backgroundColor = [UIColor clearColor];
    budget.textAlignment = NSTextAlignmentRight;
    [budget sizeToFit];
    
    [view addSubview:budget];
  }
  
  
  
  
  
  
  
  return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                             icon:[UIImage imageNamed:@"Checkmark"]];
    
    
//    [rightUtilityButtons addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                             title:@"More"];
    [rightUtilityButtons addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                             title:@"Delete"];
    
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:CellIdentifier
                              containingTableView:tableView // For row height and selection
                               leftUtilityButtons:leftUtilityButtons
                              rightUtilityButtons:rightUtilityButtons];
    cell.delegate = self;
  }

  Bundle *bundle = [self.bundles objectAtIndex:indexPath.section];
  Widget *widget = [bundle.widgets objectAtIndex:indexPath.row];
  
  if ([widget collected]) {
    NSAttributedString *theAttributedString;
    theAttributedString = [[NSAttributedString alloc] initWithString:widget.name attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
    cell.textLabel.attributedText = theAttributedString;
    
  } else {
    cell.textLabel.text = widget.name;
  }
  
  NSString *details = @"";
  if (widget.quantity == nil || [widget.quantity integerValue] == 0) {
    details = [details stringByAppendingString:@"1"];
  } else {
    details = [details stringByAppendingString:[widget.quantity stringValue]];
  }
  
  if (widget.budget != nil) {
    details = [details stringByAppendingFormat:@" with %@", [NSNumberFormatter localizedStringFromNumber:widget.budget
                                                                                          numberStyle:NSNumberFormatterCurrencyStyle]];
  }
  
  
  
  cell.detailTextLabel.text = details;
  
  
  
  return cell;
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
  switch (index) {
    case 0:
      NSLog(@"check button was pressed");
      NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
      Bundle *bundle = [self.bundles objectAtIndex:indexPath.section];
      Widget *widget = [bundle.widgets objectAtIndex:indexPath.row];
      [widget collect];
      break;
//    case 1:
//      NSLog(@"clock button was pressed");
//      break;
//    case 2:
//      NSLog(@"cross button was pressed");
//      break;
//    case 3:
//      NSLog(@"list button was pressed");
  }
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  Bundle *bundle = [self.bundles objectAtIndex:indexPath.section];
  Widget *widget = [bundle.widgets objectAtIndex:indexPath.row];
  
  switch (index) {
//    case 0:
//      NSLog(@"More button was pressed");
//      break;
    case 0:
    {
      // Delete button was pressed
      [widget remove];
      NSLog(@"delete button was pressed");
      break;
    }
    default:
      break;
  }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  if([[segue identifier] isEqualToString:@"widgetForm"]) {
    WidgetViewController *widgetViewController = segue.destinationViewController;
    widgetViewController.bundles = self.bundles;
  }
  //    RWItemViewController *itemsViewController = segue.destinationViewController;
  //    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  //    self.selectedCategory = [self.categories objectAtIndex:indexPath.row];
  //    itemsViewController.category = self.selectedCategory;
  //  }
}


- (IBAction)showMenu
{
  [self.frostedViewController presentMenuViewController];
}


@end
