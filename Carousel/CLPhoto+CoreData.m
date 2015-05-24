//
//  CLPhoto+CoreData.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CLPhoto+CoreData.h"
#import "Flickr.h"

@implementation CLPhoto (CoreData)

+(void)loadPhotos {
    if ([CLPhoto photosCount] == 0) {
        [CLPhoto addPhotos:[Flickr getAllPhotos]];
    }
}

+(void)addPhoto:(NSData *)image toPhotoWithURL:(NSString *)url {
    NSArray *fetchedObjects = [CLPhoto photos];
    for (CLPhoto *photo in fetchedObjects) {
        if ([url isEqualToString:photo.url]) {
            photo.image = image;
            [[CLCoreDataManager defaultManager] saveContext];
        }
    }
}

#pragma mark - Helper

+(NSUInteger)photosCount {
    NSArray *fetchedObjects = [CLPhoto photos];
    if (fetchedObjects == nil) {
        return 0;
    } else {
        return [fetchedObjects count];
    }
}

+(NSArray *)photos {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CLPhoto" inManagedObjectContext:[[CLCoreDataManager defaultManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[[CLCoreDataManager defaultManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+(void)addPhotos:(NSArray *)photos {
    for (NSDictionary *dictionary in photos) {
        [CLPhoto addPhotoWithFlickrDictionary:dictionary];
    }
}

+(void)addPhotoWithFlickrDictionary:(NSDictionary *)dictionary {
    CLPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"CLPhoto" inManagedObjectContext:[[CLCoreDataManager defaultManager] managedObjectContext]];
    photo.unique = dictionary[FLICKR_PHOTO_ID];
    photo.name = ([dictionary[FLICKR_PHOTO_NAME] isEqualToString:@""]) ? @"Untitled" : dictionary[FLICKR_PHOTO_NAME];
    photo.url = dictionary[FLICKR_PHOTO_URL];
    [[CLCoreDataManager defaultManager] saveContext];
}


@end
