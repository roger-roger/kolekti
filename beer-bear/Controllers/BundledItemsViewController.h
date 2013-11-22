//
//  BundledItemsViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/10/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "SWTableViewCell.h"

@interface BundledItemsViewController : UITableViewController <SWTableViewCellDelegate>

@property (nonatomic,strong) NSArray* households;

- (IBAction)showMenu;
- (IBAction)pullRefresh;

@end
