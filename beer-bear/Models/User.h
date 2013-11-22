//
//  User.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *households;

-(void)save;

+(User *)current;
-(void)loadCurrent;

@end
