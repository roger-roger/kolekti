//
//  RWCategory.m
//  kolekti
//
//  Created by Ryan Faerman on 10/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWCategory.h"
#import "RWItem.h"

@implementation RWCategory

+ (RWCategory *)stub:(NSString *)useName {
  RWCategory *category = [[self alloc] init];
  
  category.name = useName;
  category.notes = @"Things to buy at this store.";
  
  
//  [category.items addObject:[RWItem stub:@{@"name": @"Gadget", @"budget": @1.45, @"quantity": @(3)}]];
  return category ;
}

- (NSNumber *)budget {
  return [[NSNumber alloc] initWithFloat: 2.25];
}

@end
