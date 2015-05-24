//
//  CLCoreDataManager.h
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CLCoreDataManager : NSObject

+(instancetype)defaultManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)saveContext;

@end
