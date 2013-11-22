//
//  RegistrationViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/15/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MZFormSheetController.h"

#import "User.h"
#import "Household.h"

@interface RegistrationViewController ()

@property (nonatomic, strong) Household *household;
@property (nonatomic, strong) User *user;
@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(householdSaved:) name:@"householdSaved" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSaved:) name:@"userSaved" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAway:) name:@"householdJoined" object:nil];
}


- (IBAction)start
{
  
  
  self.household = [Household new];
  self.household.name = self.householdField.text;
  [self.household save];

}

-(void)householdSaved:(NSNotification *)notification
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  self.household.householdID = [[NSNumber alloc] initWithInt:[preferences integerForKey:@"household_id"]];
  self.user = [User new];
  self.user.name = self.nameField.text;
  [self.user save];
}

-(void)userSaved:(NSNotification *)notification
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  self.user.userID = [[NSNumber alloc] initWithInt:[preferences integerForKey:@"user_id"]];
  [self.household addUser:[self.user.userID integerValue]];
}

-(void)goAway:(NSNotification *)notification
{
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

@end
