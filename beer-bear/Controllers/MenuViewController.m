//
//  MenuViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/10/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "MZFormSheetController.h"
#import "Household.h"
#import "User.h"

@interface MenuViewController ()
@property (nonatomic, strong) UILabel *householdLabel;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHouseholdLoaded:) name:@"householdLoaded" object:nil];
  
	self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.opaque = NO;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.tableHeaderView = ({
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    imageView.image = [UIImage imageNamed:@"Avatar"];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    self.householdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    self.householdLabel.text = [[Household current].name stringByAppendingFormat:@"(%@)",[Household current].householdID];
    
    self.householdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    self.householdLabel.backgroundColor = [UIColor clearColor];
    self.householdLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [self.householdLabel sizeToFit];
    self.householdLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:imageView];
    [view addSubview:self.householdLabel];
    view;
  });
  
}

-(void)handleHouseholdLoaded:(NSNotification *)notification
{
  self.householdLabel.text = [[Household current].name stringByAppendingFormat:@"(%@)",[Household current].householdID];
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
  cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
  if (sectionIndex == 0)
    return nil;
  
  
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
  view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
  label.text = @"Household Members";
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  [label sizeToFit];
  
  
  
  [view addSubview:label];
  
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
  if (sectionIndex == 0)
    return 0;
  
  return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
  //
  //  if (indexPath.section == 0 && indexPath.row == 0) {
  //    DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
  //    navigationController.viewControllers = @[homeViewController];
  //  } else {
  //    DEMOSecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
  //    navigationController.viewControllers = @[secondViewController];
  //  }
  if (indexPath.section == 0 && indexPath.row == 3) {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"joinHousehold"];
    
    MZFormSheetController *joinHouseholdForm = [[MZFormSheetController alloc] initWithViewController:vc];
    joinHouseholdForm.shouldDismissOnBackgroundViewTap = YES;
    
    
    [self presentFormSheetController:joinHouseholdForm animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
      [self.frostedViewController hideMenuViewController];
    }];
  }
  if (indexPath.section == 0 && indexPath.row == 2) {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"householdSwitcher"];
    
    MZFormSheetController *householdSwitcher = [[MZFormSheetController alloc] initWithViewController:vc];
    householdSwitcher.shouldDismissOnBackgroundViewTap = YES;
    
    
    [self presentFormSheetController:householdSwitcher animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
      [self.frostedViewController hideMenuViewController];
    }];
  }
  
  if (indexPath.section == 0 && indexPath.row == 1) {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryManager"];
    navigationController.viewControllers = @[vc];
    [self.frostedViewController hideMenuViewController];
    //    MZFormSheetController *householdSwitcher = [[MZFormSheetController alloc] initWithViewController:vc];
    //    householdSwitcher.shouldDismissOnBackgroundViewTap = YES;
    //
    //
    //    [self presentFormSheetController:householdSwitcher animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    //      [self.frostedViewController hideMenuViewController];
    //    }];
  }
  
  if (indexPath.section == 0 && indexPath.row == 0) {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
    navigationController.viewControllers = @[vc];
    [self.frostedViewController hideMenuViewController];
  }
  
  
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  if (sectionIndex == 0) {
    return 4;
  } else {
    return [Household current].users.count;
  }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  if (indexPath.section == 0) {
    NSArray *titles = @[@"Stores & Widgets", @"Modify Stores", @"Switch Household", @"Join Household"];
    cell.textLabel.text = titles[indexPath.row];
  } else {
//    NSArray *titles = @[@"John Appleseed", @"John Doe", @"Alfred E. Neuman", @"Leroy Jenkins", @"Peter Parker"];
    
    User *aUser = [[Household current].users objectAtIndex:indexPath.row];
    cell.textLabel.text = [aUser.name stringByAppendingFormat:@"(%@)", aUser.userID];
  }
  
  return cell;
}

@end
