//
//  WidgetViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/10/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *bundles;

@property (nonatomic, strong) NSNumber *widgetID;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *quantityField;
@property (nonatomic, strong) IBOutlet UITextField *budgetField;
@property (nonatomic, strong) IBOutlet UIPickerView *bundlePicker;

- (IBAction)cancel;
- (IBAction)save;

@end
