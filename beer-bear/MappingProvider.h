//
//  MappingProvider.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvider : NSObject

+ (RKMapping *)widgetMapping;
+ (RKMapping *)bundleMapping;
+ (RKMapping *)householdMapping;
+ (RKMapping *)userMapping;

//+ (RKMapping *)householdSyncMapping;
//+ (RKMapping *)bundleSyncMapping;
//+ (RKMapping *)widgetSyncMapping;

@end
