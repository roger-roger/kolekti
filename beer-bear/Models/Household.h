//
//  Household.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Household : NSObject

@property (nonatomic, strong) NSNumber *householdID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *bundles;
@property (nonatomic, strong) NSArray *users;

-(void)save;
-(void)addUser:(int)user_id;
-(void)loadCurrent;

+(Household *)current;

@end
