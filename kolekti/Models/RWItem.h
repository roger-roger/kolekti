//
//  RWItem.h
//  kolekti
//
//  Created by Ryan Faerman on 10/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWItem : NSObject

@property (nonatomic, copy) NSNumber *itemID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *quantity;
@property (nonatomic, copy) NSNumber *budget;
@property (nonatomic, copy) NSString *notes;

+ (RWItem *)stub:(NSDictionary *)data;

@end
