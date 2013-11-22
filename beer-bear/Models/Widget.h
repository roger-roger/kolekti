//
//  Widget.h
//  beer-bear
//
//  Created by Ryan Faerman on 11/6/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Widget : NSObject

@property (nonatomic, copy) NSNumber *widgetID;
@property (nonatomic, copy) NSNumber *bundleID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSNumber *quantity;
@property (nonatomic, copy) NSNumber *budget;

-(void)save;
-(void)collect;
-(void)remove;

-(BOOL)collected;

@end
