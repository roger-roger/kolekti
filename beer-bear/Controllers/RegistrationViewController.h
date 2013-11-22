//
//  RegistrationViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/15/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *householdField;

- (IBAction)start;

@end
