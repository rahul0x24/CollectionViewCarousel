//
//  CLPhoto+CoreData.h
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CLPhoto.h"

@interface CLPhoto (CoreData)

+(void)loadPhotos;
+(void)addPhoto:(NSData *)image toPhotoWithURL:(NSString *)url;

@end
