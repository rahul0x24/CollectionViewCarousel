//
//  Flickr.h
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_NAME @"title"
#define FLICKR_PHOTO_URL @"url"

@interface Flickr : NSObject

+(NSArray *)getAllPhotos;

@end
