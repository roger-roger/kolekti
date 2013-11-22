//
//  KolektiDataModel.m
//  beer-bear
//
//  Created by Ryan Faerman on 11/7/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "KolektiDataModel.h"
#import <CoreData/CoreData.h>

@implementation KolektiDataModel

+ (id)sharedDataModel {
  static KolektiDataModel *__sharedDataModel = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __sharedDataModel = [[KolektiDataModel alloc] init];
  });
  
  return __sharedDataModel;
}

- (NSManagedObjectModel *)managedObjectModel {
  return [NSManagedObjectModel mergedModelFromBundles:nil];
}

- (id)optionsForSqliteStore {
  return @{
           NSInferMappingModelAutomaticallyOption: @YES,
           NSMigratePersistentStoresAutomaticallyOption: @YES
           };
}

- (void)setup {
  self.objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"kolekiData.sqlite"];
  NSLog(@"Setting up store at %@", path);
  [self.objectStore addSQLitePersistentStoreAtPath:path
                            fromSeedDatabaseAtPath:nil
                                 withConfiguration:nil
                                           options:[self optionsForSqliteStore]
                                             error:nil];
  [self.objectStore createManagedObjectContexts];
}

@end
