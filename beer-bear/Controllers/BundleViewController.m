//
//  BundleViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/13/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "BundleViewController.h"
#import "MZFormSheetController.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "SWTableViewCell.h"

#import "MappingProvider.h"

#import "Household.h"
#import "Bundle.h"

@interface BundleViewController ()
@property (nonatomic, strong) NSArray *bundles;
@end

@implementation BundleViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
  [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
  
  self.title = @"Stores";
  
  self.bundles = @[];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBundleSave:) name:@"bundleSaved" object:nil];
  
  [self loadBundles];
}

-(void)handleBundleSave:(NSNotification *)notification
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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.bundles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [leftUtilityButtons addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
//                                            title:@"Edit"];
    
    
    [rightUtilityButtons addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
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
  
  Bundle *bundle = [self.bundles objectAtIndex:indexPath.row];
  cell.textLabel.text = bundle.name;
  cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:bundle.budget
                                                               numberStyle:NSNumberFormatterCurrencyStyle];
  
  return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  Bundle *bundle = [self.bundles objectAtIndex:indexPath.row];
  
  switch (index) {
    case 0:
    {
      NSLog(@"Edit button was pressed");
      break;
    }
    case 1:
    {
      // Delete button was pressed
      [bundle remove];
      NSLog(@"delete button was pressed");
      break;
    }
    default:
      break;
  }
}

- (IBAction)showMenu
{
  [self.frostedViewController presentMenuViewController];
}

@end
