//
//  AppDelegate.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "MappingProvider.h"
#import "Household.h"
#import "Bundle.h"
#import "Widget.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  UIStoryboard *appropriateStoryboard = [self storyboard];
  self.window.rootViewController = [appropriateStoryboard instantiateInitialViewController];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
//  [preferences removeObjectForKey:@"user_id"];
//  [preferences removeObjectForKey:@"household_id"];
  if ([preferences integerForKey:@"user_id"] > 0 && [preferences integerForKey:@"household_id"] > 0) {
    [Household current];
    [User current];
  };
  
  return YES;
}

- (UIStoryboard *)storyboard {
  NSString *storyboardName = @"Storyboard";
  if ([self isPad]) {
    storyboardName = [storyboardName stringByAppendingString:@"_Pad"];
  }
  return [UIStoryboard storyboardWithName:storyboardName bundle:nil];
}

- (BOOL)isPad {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)loadHouseholds
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];

  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:@"/api/households"
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  NSURL *url = [NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me/api/households"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                      responseDescriptors:@[responseDescriptor]];
  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
    for (Household *household in mappingResult.array) {
      NSLog(@"Household: %@", household.name);
      
      for (Bundle *bundle in household.bundles) {
        NSLog(@"With Bundle: %@", bundle.name);
        
        for (Widget *widget in bundle.widgets) {
          NSLog(@"With Widgets: %@, %@", widget.name, widget.quantity);
        }
      }
    }
    
    [SVProgressHUD dismiss];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    NSLog(@"ERROR: %@", error);
    NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
    [SVProgressHUD showErrorWithStatus:@"Request failed"];
  }];
  
  [SVProgressHUD show];
  [operation start];
  
//  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
//  [requestMapping addAttributeMappingsFromArray:@[@"name"]];
//  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
//                                                                                 objectClass:[Household class]
//                                                                                 rootKeyPath:nil
//                                                                                      method:RKRequestMethodAny];
//  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
//  [manager addRequestDescriptor:requestDescriptor];
//  [manager addResponseDescriptor:responseDescriptor];
//  
//  Household *household = [Household new];
//  household.name = @"October Fest";
//  
//  [manager postObject:household path:@"/api/households" parameters:nil success:nil failure:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"widgetSaved" object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
