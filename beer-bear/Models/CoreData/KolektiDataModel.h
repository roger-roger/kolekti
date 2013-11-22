//
//  KolektiDataModel.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/7/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/RKManagedObjectStore.h>

@interface KolektiDataModel : NSObject

@property (nonatomic, strong) RKManagedObjectStore *objectStore;

+ (id)sharedDataModel;
- (void)setup;

@end
