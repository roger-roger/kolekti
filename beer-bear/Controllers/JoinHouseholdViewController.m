//
//  JoinHouseholdViewController.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/16/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "JoinHouseholdViewController.h"
#import "MZFormSheetController.h"
#import "Household.h"
#import "User.h"

@interface JoinHouseholdViewController ()

@end

@implementation JoinHouseholdViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(householdJoined:) name:@"householdJoined" object:nil];
}

-(IBAction)join
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  int current_user = [preferences integerForKey:@"user_id"];
  
  Household *household = [Household new];
  household.householdID = [[NSNumber alloc] initWithInt:[self.householdField.text integerValue]];
  [household addUser:current_user];
  
  
  
}

-(void)householdJoined:(NSNotification *)notification
{
  [[User current] loadCurrent];
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"householdSwitcher"];
    
    MZFormSheetController *householdSwitcher = [[MZFormSheetController alloc] initWithViewController:vc];
    householdSwitcher.shouldDismissOnBackgroundViewTap = YES;
    
    
    [self presentFormSheetController:householdSwitcher animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
      
    }];
  }];
}

- (IBAction)cancel
{
  [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    
  }];
}

@end
