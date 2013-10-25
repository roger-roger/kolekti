//
//  RWItemViewController.m
//  kolekti
//
//  Created by Ryan Faerman on 10/23/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWItemViewController.h"
#import "RWItemCell.h"
#import "RWItem.h"
#import "RWItemDrawerCell.h"

@interface RWItemViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation RWItemViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadItems];
}

- (void)loadItems
{
  self.items = [[NSArray alloc] initWithObjects:
                [RWItem stub:@{@"name": @"Onions", @"budget": @1.45, @"quantity": @(3)}],
                [RWItem stub:@{@"name": @"Tomatoes", @"budget": @10.00, @"quantity": @(14)}],
                [RWItem stub:@{@"name": @"Carrots", @"budget": @3.75, @"quantity": @(6)}],
                nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = @"itemCell";
  
  if (indexPath.row % 2) {
    CellIdentifier = @"itemCellChecked";
  }
  
  RWItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  RWItem *item = [self.items objectAtIndex:indexPath.row];
  
  [self configureCell:cell withItem:item];
    
  return cell;
}

- (void)configureCell:(RWItemCell *)cell withItem:(RWItem *)item
{
  
  cell.budgetLabel.text = [NSNumberFormatter localizedStringFromNumber:item.budget
                                                                   numberStyle:NSNumberFormatterCurrencyStyle];
  NSString *description = @"";
  
  if (item.quantity) {
    description = [description stringByAppendingFormat: @"%@ ", [NSNumberFormatter localizedStringFromNumber:item.quantity
                                                                                        numberStyle:NSNumberFormatterDecimalStyle]];
  }
  
  description = [description stringByAppendingString:item.name];
  
  cell.descriptionLabel.text = description;
  
  RWItemDrawerCell *drawerView = [[RWItemDrawerCell alloc] initWithFrame:cell.frame];
  cell.drawerView = drawerView;
  cell.directionMask = HHPanningTableViewCellDirectionRight;
}

@end
