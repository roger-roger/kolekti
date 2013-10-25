//
//  RWCategoryViewController.m
//  kolekti
//
//  Created by Ryan Faerman on 10/23/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWCategoryViewController.h"
#import "RWItemViewController.h"
#import "RWCategory.h"
#import "RWCategoryCell.h"
#import "RWCategoryDrawerCell.h"
#import "RWCategoryFormViewController.h"

@interface RWCategoryViewController ()

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) RWCategory *selectedCategory;

@end

@implementation RWCategoryViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.categories = @[[RWCategory stub:@"Publix"], [RWCategory stub:@"Best Buy"], [RWCategory stub:@"Barnes & Nobles"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = @"categoryCell";
  
  switch (indexPath.row % 3) {
    case 1:
      CellIdentifier = @"categoryCellOrange";
      break;
    case 2:
      CellIdentifier = @"categoryCellBlue";
      break;
    default:
      CellIdentifier = @"categoryCell";
      break;
  }
  
  RWCategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                              forIndexPath:indexPath];
  RWCategory *category = [self.categories objectAtIndex:indexPath.row];
  
  [self configureCell:cell forCategory:category];
  return cell;
}

- (void)configureCell:(RWCategoryCell *)cell forCategory:(RWCategory *)category
{
  cell.categoryNameLabel.text = category.name;
  cell.categoryBudgetLabel.text = [NSNumberFormatter localizedStringFromNumber:category.budget
                                                                   numberStyle:NSNumberFormatterCurrencyStyle];
  RWCategoryDrawerCell *drawerView = [[RWCategoryDrawerCell alloc] initWithFrame:cell.frame];
  cell.drawerView = drawerView;
  cell.directionMask = HHPanningTableViewCellDirectionRight;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
  if([[segue identifier] isEqualToString:@"edit"]) {
    
  } else {
    RWItemViewController *itemsViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedCategory = [self.categories objectAtIndex:indexPath.row];
    itemsViewController.category = self.selectedCategory;
  }
 
}


@end
