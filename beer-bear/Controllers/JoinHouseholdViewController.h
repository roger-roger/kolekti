//
//  JoinHouseholdViewController.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/16/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinHouseholdViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *householdField;

-(IBAction)join;
-(IBAction)cancel;

@end
