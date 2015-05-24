//
//  CLImageDownloadManager.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CLImageDownloadManager.h"

@interface CLImageDownloadManager () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end

@implementation CLImageDownloadManager

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSString *stringURL = [self.imageURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:stringURL];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.imageConnection = conn;
    } else {
        if (self.completionHandler)
            self.completionHandler(self, nil);
    }
    
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    if (self.completionHandler)
        self.completionHandler(self, nil);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completionHandler)
        self.completionHandler(self, self.activeDownload);
    
    // Set appIcon and clear temporary data/image
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
}

@end
