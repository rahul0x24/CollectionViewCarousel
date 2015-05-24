//
//  CLImageDownloadManager.h
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLImageDownloadManager : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, copy) void (^completionHandler)(CLImageDownloadManager *idm, NSData *image);

- (void)startDownload;
- (void)cancelDownload;

@end
