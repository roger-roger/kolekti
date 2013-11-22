//
//  User.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "User.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "MappingProvider.h"
#import "Household.h"

@implementation User

-(void)save
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider userMapping];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = @"/api/members";
  
  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name"]];
  [requestMapping addAttributeMappingsFromDictionary:@{@"userID": @"id"}];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];
  
  if (self.userID) {
    // update
    pathPattern = [pathPattern stringByAppendingFormat:@"%@.json", self.userID];
    [manager patchObject:self path:pathPattern parameters:nil success:nil failure:nil];
  } else {
    // create
    [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      
      NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
      NSArray *results = mappingResult.array;
      User *user = [results objectAtIndex:0];
      [preferences setObject:user.userID forKey:@"user_id"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"userSaved" object:self];
    } failure:nil];
  }
  
}

+(User *)current
{
  static User *__user = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __user = [[User alloc] init];
    [__user loadCurrent];
  });
  
  return __user;
}

-(void)loadCurrent
{
  [SVProgressHUD show];
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/members/" stringByAppendingFormat:@"%ld", (long)[preferences integerForKey:@"user_id"]];
  
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  NSURL *url = [NSURL URLWithString:[@"http://wolverine.kolekti-api.c66.me" stringByAppendingString:pathPattern]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                      responseDescriptors:@[responseDescriptor]];
  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    NSArray *household_response = mappingResult.array;
    Household *theHousehold = [household_response objectAtIndex:0];
    User *theUser = nil;
    
    for (User *aUser in theHousehold.users) {
      if ([aUser.userID integerValue] == [preferences integerForKey:@"user_id"]) {
        theUser = aUser;
        break;
      }
    }
    
    self.name = theUser.name;
    self.households = mappingResult.array;
    self.userID = theUser.userID;
    
    [SVProgressHUD dismiss];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    NSLog(@"ERROR: %@", error);
    NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
    [SVProgressHUD showErrorWithStatus:@"Request failed"];
  }];
  
  [SVProgressHUD show];
  [operation start];
}

@end
