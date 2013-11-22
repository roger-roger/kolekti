//
//  BundleFormViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/13/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BundleFormViewController : UIViewController


@property (nonatomic, strong) NSNumber *bundleID;
@property (nonatomic, strong) IBOutlet UITextField *nameField;

- (IBAction)cancel;
- (IBAction)save;

@end
