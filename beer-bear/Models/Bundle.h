//
//  Bundle.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bundle : NSObject

@property (nonatomic, copy) NSNumber *bundleID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *widgets;

-(NSNumber*)budget;

-(void)save;
-(void)remove;

@end
