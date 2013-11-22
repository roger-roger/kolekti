//
//  BundleFormViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/13/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "BundleFormViewController.h"
#import "MZFormSheetController.h"

#import "Bundle.h"

@interface BundleFormViewController ()

@end

@implementation BundleFormViewController

- (IBAction)cancel
{
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

- (IBAction)save
{
  
  Bundle *bundle = [Bundle new];
  bundle.name = self.nameField.text;
  
  bundle.bundleID = self.bundleID;
  
  [bundle save];
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

@end
