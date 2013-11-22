//
//  Widget.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "Widget.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "MappingProvider.h"

@implementation Widget

-(BOOL)collected
{
  return [self.state isEqual: @"collected"];
}

-(void)save
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/households/" stringByAppendingFormat:@"%ld/bundles/%@/widgets", (long)[preferences integerForKey:@"household_id"], self.bundleID];
//  NSString *pathPattern = [@"/api/households/3/bundles/" stringByAppendingFormat:@"%@/widgets", self.bundleID];

  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name", @"budget", @"quantity"]];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];
  
  if (self.widgetID) {
    // update
    pathPattern = [pathPattern stringByAppendingFormat:@"%@.json", self.widgetID];
    [manager patchObject:self path:pathPattern parameters:nil success:nil failure:nil];
  } else {
    // create
    [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"widgetSaved" object:self];
    } failure:nil];
  }
  
}

-(void)collect
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSString *pathPattern = [@"/api/households/3/bundles/" stringByAppendingFormat:@"%@/widgets/%@/collected", self.bundleID, self.widgetID];
  
  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name", @"budget", @"quantity"]];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];
  
  [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"widgetSaved" object:self];
  } failure:nil];
}

-(void)remove
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSString *pathPattern = [@"/api/households/3/bundles/" stringByAppendingFormat:@"%@/widgets/%@.json", self.bundleID, self.widgetID];
  
  RKResponseDescriptor *responseDescriptor  =[RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                     pathPattern:pathPattern
                                                                                         keyPath:nil
                                                                                     statusCodes:statusCodeSet];
  
  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  [requestMapping addAttributeMappingsFromArray:@[@"name"]];
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                 objectClass:[self class]
                                                                                 rootKeyPath:nil
                                                                                      method:RKRequestMethodAny];
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wolverine.kolekti-api.c66.me"]];
  [manager addRequestDescriptor:requestDescriptor];
  [manager addResponseDescriptor:responseDescriptor];
  
  [manager deleteObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"widgetSaved" object:self];
  } failure:nil];
}

@end
