//
//  RWItemCell.h
//  kolekti
//
//  Created by Ryan Faerman on 10/23/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPanningTableViewCell.h"

@interface RWItemCell : HHPanningTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *budgetLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end
