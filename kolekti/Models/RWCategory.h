//
//  RWCategory.h
//  kolekti
//
//  Created by Ryan Faerman on 10/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWCategory : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *notes;

@property (nonatomic, readonly) NSNumber *budget;

@property (nonatomic, copy) NSMutableArray *items;

+ (RWCategory *)stub:(NSString *)useName;


@end
