//
//  RWCategoryDrawerCell.m
//  kolekti
//
//  Created by Ryan Faerman on 10/24/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWCategoryDrawerCell.h"
#import "BButton.h"

@implementation RWCategoryDrawerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      CGRect frame = CGRectMake(0.0f, 0.0f, 112.0f, 50.0f);
      [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
      BButton *btn = [[BButton alloc] initWithFrame:frame type:BButtonTypePrimary style:BButtonStyleBootstrapV3];
      [btn setTitle:@"Hello" forState:UIControlStateNormal];
      
      self.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
      
      [self addSubview:btn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
