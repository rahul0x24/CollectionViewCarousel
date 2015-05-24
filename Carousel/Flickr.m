//
//  Flickr.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "Flickr.h"

#define FLICKR_API_KEY @"ae8f7d5c23897676a395a037fc223a15"

#define FLICKR_FARM_ID @"farm"
#define FLICKR_SERVER_ID @"server"
#define FLICKR_SECRET @"secret"

@implementation Flickr

+(NSArray *)getAllPhotos {
    NSMutableArray *photoArray = [[NSMutableArray alloc] initWithCapacity:50];
    
    NSArray *jsonArray = [Flickr getJsonArrayFromURLString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&per_page=15&format=json&nojsoncallback=1",FLICKR_API_KEY]];
    
    for (NSDictionary *dict in jsonArray) {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        [d setValuesForKeysWithDictionary:dict];
        [d setObject:[Flickr photoURLWithFlickrDictionary:dict] forKey:FLICKR_PHOTO_URL];
        [photoArray addObject:d];
    }
    return photoArray;
}

+(NSArray *)getJsonArrayFromURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *jsonArray;
    NSError *error = nil;
    NSString *json = [NSString stringWithContentsOfURL:url
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
    
    if(!error) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:kNilOptions
                                                      error:&error];
    }
    return [jsonArray valueForKeyPath:@"photos.photo"];
}

+(NSString *)photoURLWithFlickrDictionary:(NSDictionary *)dictionary {
    return [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg",dictionary[FLICKR_FARM_ID],dictionary[FLICKR_SERVER_ID],dictionary[FLICKR_PHOTO_ID],dictionary[FLICKR_SECRET]];
}

@end
