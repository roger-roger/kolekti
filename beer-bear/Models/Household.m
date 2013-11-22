//
//  Household.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "Household.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "MappingProvider.h"

@implementation Household


-(void)save
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSString *pathPattern = @"/api/households";
  
  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name"]];
  [requestMapping addAttributeMappingsFromDictionary:@{@"householdID": @"id"}];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];
  
  if (self.householdID) {
    // update
    pathPattern = [pathPattern stringByAppendingFormat:@"%@.json", self.householdID];
    [manager patchObject:self path:pathPattern parameters:nil success:nil failure:nil];
  } else {
    // create
    [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      
      NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
      NSArray *results = mappingResult.array;
      Household *house = [results objectAtIndex:0];
      [preferences setObject:house.householdID forKey:@"household_id"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"householdSaved" object:self];
    } failure:nil];
  }
  
}

-(void)addUser:(int)user_id
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/households/" stringByAppendingFormat:@"%@/members/%d", self.householdID, user_id];
  
  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name"]];
  [requestMapping addAttributeMappingsFromDictionary:@{@"householdID": @"id"}];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];

  // create
  [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"householdJoined" object:self];
  } failure:nil];
  
}

+(Household *)current
{
  static Household *__household = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __household = [[Household alloc] init];
    [__household loadCurrent];
  });
  
  return __household;
}

-(void)loadCurrent
{
  [SVProgressHUD show];
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/households/" stringByAppendingFormat:@"%ld", (long)[preferences integerForKey:@"household_id"]];
  
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
    self.name = theHousehold.name;
    self.users = theHousehold.users;
    self.bundles = theHousehold.bundles;
    self.householdID = theHousehold.householdID;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"householdLoaded" object:self];
    
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
