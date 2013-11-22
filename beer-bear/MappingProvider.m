//
//  MappingProvider.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "MappingProvider.h"

#import "Widget.h"
#import "Bundle.h"
#import "Household.h"
#import "User.h"

@implementation MappingProvider

+ (RKMapping *)widgetMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Widget class]];
  [mapping addAttributeMappingsFromArray:@[@"name", @"quantity", @"state", @"budget"]];
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"id": @"widgetID",
                                                @"bundle_id": @"bundleID"
                                                }];
  return mapping;
}

+ (RKMapping *)bundleMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Bundle class]];
  
  [mapping addAttributeMappingsFromArray:@[@"name"]];
  [mapping addAttributeMappingsFromDictionary:@{@"id": @"bundleID"}];
  [mapping addRelationshipMappingWithSourceKeyPath:@"widgets"
                                           mapping:[MappingProvider widgetMapping]];
  return mapping;
}

+ (RKMapping *)householdMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Household class]];
  [mapping addAttributeMappingsFromArray:@[@"name"]];
  [mapping addAttributeMappingsFromDictionary:@{@"id": @"householdID"}];
  [mapping addRelationshipMappingWithSourceKeyPath:@"bundles"
                                           mapping:[MappingProvider bundleMapping]];
  [mapping addRelationshipMappingWithSourceKeyPath:@"users"
                                           mapping:[MappingProvider userMapping]];
  return mapping;
}

+ (RKMapping *)userMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
  [mapping addAttributeMappingsFromArray:@[@"name"]];
  [mapping addAttributeMappingsFromDictionary:@{@"id": @"userID"}];
  
  return mapping;
}

@end
