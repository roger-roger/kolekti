//
//  RWItemViewController.h
//  kolekti
//
//  Created by Ryan Faerman on 10/23/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWCategory.h"

@interface RWItemViewController : UITableViewController

@property (nonatomic, strong) RWCategory *category;

@end
