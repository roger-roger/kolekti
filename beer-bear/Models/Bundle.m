//
//  Bundle.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "Bundle.h"
#import "Widget.h"

#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"
#import "MappingProvider.h"

@implementation Bundle

-(NSNumber*)budget
{
  NSNumber *budget = @0;
  
  if (self.widgets.count > 0) {
    for (Widget *widget in self.widgets) {
      float added = [budget floatValue] + [widget.budget floatValue];
      budget = [NSNumber numberWithFloat:added];
    }
  }
  
  return budget;
}

-(void)save
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSString *pathPattern = [@"/api/households/" stringByAppendingFormat:@"%ld/bundles", (long)[preferences integerForKey:@"household_id"]];
  
//  NSString *pathPattern = @"/api/households/3/bundles/";
  
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
  
  if (self.bundleID) {
    // update
    pathPattern = [pathPattern stringByAppendingFormat:@"%@.json", self.bundleID];
    [manager patchObject:self path:pathPattern parameters:nil success:nil failure:nil];
  } else {
    // create
    [manager postObject:self path:pathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"bundleSaved" object:self];
    } failure:nil];
  }
  
}

-(void)remove
{
  NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKMapping *mapping = [MappingProvider householdMapping];
  
  NSString *pathPattern = [@"/api/households/3/bundles/" stringByAppendingFormat:@"%@.json", self.bundleID];
  
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bundleSaved" object:self];
  } failure:nil];
}

@end
