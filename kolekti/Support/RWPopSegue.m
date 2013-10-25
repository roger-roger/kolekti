//
//  RWPopSegue.m
//  kolekti
//
//  Created by Ryan Faerman on 10/24/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWPopSegue.h"

@implementation RWPopSegue


- (void) perform {
  [self.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
