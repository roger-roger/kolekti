//
//  BundleViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/13/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "SWTableViewCell.h"

@interface BundleViewController : UITableViewController <SWTableViewCellDelegate>
- (IBAction)showMenu;
- (IBAction)pullRefresh;
@end
