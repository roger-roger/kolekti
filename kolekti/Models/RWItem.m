//
//  RWItem.m
//  kolekti
//
//  Created by Ryan Faerman on 10/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWItem.h"

@implementation RWItem

+ (RWItem *)stub:(NSDictionary *)data
{
  RWItem *item = [[self alloc] init];
  
  item.name = [data objectForKey:@"name"];
  item.quantity = [data objectForKey:@"quantity"];
  item.budget = [data objectForKey:@"budget"];
  
  return item;
}

@end
