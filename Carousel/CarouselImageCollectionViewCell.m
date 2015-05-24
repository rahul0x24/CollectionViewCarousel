//
//  CarouselImageCollectionViewCell.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CarouselImageCollectionViewCell.h"

//Model
#import "CLPhoto+CoreData.h"

//Helper
#import "CLImageDownloadManager.h"

@interface CarouselImageCollectionViewCell ()

//Outlets
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIView *viewLabelBackgournd;

@end

@implementation CarouselImageCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    [self customizeViewAppearance];
}

-(void)setPhoto:(CLPhoto *)photo {
    _photo = photo;
    [self setViewData];
}

#pragma mark - Helpers

-(void)customizeViewAppearance {
    [self setBackgroundColor:[UIColor clearColor]];
    [self.labelName setTextColor:[UIColor redColor]];
    [self.viewLabelBackgournd setAlpha:0.3f];
}

-(void)setViewData {
    self.imageView.image = nil;
    [self setupImage];
    self.labelName.text = self.photo.name;
}

-(void)setupImage {
    if (self.photo.image) {
        self.imageView.image = [UIImage imageWithData:self.photo.image];
    } else {
        CLImageDownloadManager *idm = [[CLImageDownloadManager alloc] init];
        [idm setImageURL:self.photo.url];
        [idm startDownload];
        [idm setCompletionHandler:^(CLImageDownloadManager *idm, NSData *image) {
            self.imageView.image = [UIImage imageWithData:image];
            [CLPhoto addPhoto:image toPhotoWithURL:idm.imageURL];
        }];
    }
}

@end
