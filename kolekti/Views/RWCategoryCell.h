//
//  RWCategoryCell.h
//  kolekti
//
//  Created by Ryan Faerman on 10/23/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPanningTableViewCell.h"

@interface RWCategoryCell : HHPanningTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *categoryNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryBudgetLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *categoryProgress;

@end
