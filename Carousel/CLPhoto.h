//
//  CLPhoto.h
//  Carousel
//
//  Created by Rahul Katariya on 12/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CLPhoto : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * unique;

@end
