//
//  WidgetViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/10/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "WidgetViewController.h"
#import "MZFormSheetController.h"

#import "Bundle.h"
#import "Widget.h"

@interface WidgetViewController ()

@property (nonatomic, strong) Bundle *selectedBundle;

@end

@implementation WidgetViewController

- (IBAction)cancel
{
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

- (IBAction)save
{
  
  Widget *widget = [Widget new];
  widget.name = self.nameField.text;
  
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  widget.quantity = [f numberFromString:self.quantityField.text];
  
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  widget.budget = [f numberFromString:self.budgetField.text];
  
  if (!_selectedBundle) {
    _selectedBundle = [self.bundles objectAtIndex:[self.bundlePicker selectedRowInComponent:0]];
  }
  
  widget.bundleID = _selectedBundle.bundleID;
  
  [widget save];
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

#pragma mark - PickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
  self.selectedBundle = [self.bundles objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.bundles.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  Bundle *bundle = [self.bundles objectAtIndex:row];
  return bundle.name;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  int sectionWidth = 300;
  
  return sectionWidth;
}

@end
