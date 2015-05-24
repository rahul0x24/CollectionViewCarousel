//
//  CarouselCollectionViewLayout.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CarouselCollectionViewLayout.h"

#define MAX_RADIANS 1.30899694
#define NINTY_DEGREE_RADIAN 1.57079633
#define TRANSFORM_M34 1.0/ -500

@interface CarouselCollectionViewLayout ()

@end

@implementation CarouselCollectionViewLayout

-(void)awakeFromNib {
    [super awakeFromNib];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0.0f;
}

-(void)setItemSize:(CGSize)itemSize {
    [super setItemSize:itemSize];
    self.sectionInset = [self sectionInsetFromItemSize:self.itemSize];
    self.minimumLineSpacing = [self minimumLineSpacingFromItemSize:self.itemSize];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//----------------------------------------------------------********----------------------------------------------------------
//            CGFloat maxDistance = self.itemSize.width + self.sectionInset.left - self.minimumLineSpacing;
//            CGFloat breakDistance = self.sectionInset.left - (2 * self.minimumLineSpacing);
//            NSLog(@"---------index %d-----------",[attributesArray indexOfObject:attributes]);
//            NSLog(@"----------distance %f------------",distanceFromCenter);
//            NSLog(@"----------max %f------------",maxDistance);
//            NSLog(@"----------collectionViewCenter %f------------",self.collectionView.center.x);
//            NSLog(@"----------attributes Center %f------------",attributes.center.x + self.collectionView.contentOffset.x);
//            NSLog(@"----------Attributes Frame %@-----------",NSStringFromCGRect(attributes.frame));
//----------------------------------------------------------********----------------------------------------------------------

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in attributesArray) {
        if (CGRectIntersectsRect(attributes.frame, visibleRect)) {
            CGFloat distanceFromCenter = self.collectionView.center.x - attributes.center.x + self.collectionView.contentOffset.x;
            CGFloat radianFactor = distanceFromCenter / ((self.itemSize.width + self.minimumLineSpacing) / MAX_RADIANS) ;
            attributes.alpha = (radianFactor > NINTY_DEGREE_RADIAN || radianFactor < -NINTY_DEGREE_RADIAN) ?  0.0f : 1.0f;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = TRANSFORM_M34;
            transform = CATransform3DRotate(transform, radianFactor, 0, 1, 0);
            attributes.transform3D = transform;
        }
    }
    return attributesArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

#pragma mark - Helpers

-(UIEdgeInsets)sectionInsetFromItemSize:(CGSize)itemSize {
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    
    CGFloat collectionViewWidth = [self collectionViewWidth];
    CGFloat collectionViewHeight = self.collectionViewContentSize.height;
    
    CGFloat verticalDistance = (collectionViewHeight - itemHeight)/2;
    CGFloat horizontalDistance = (collectionViewWidth - itemWidth)/2;
    return UIEdgeInsetsMake(verticalDistance, horizontalDistance, verticalDistance, horizontalDistance);
}

-(CGFloat)minimumLineSpacingFromItemSize:(CGSize)itemSize {
    CGFloat itemWidth = itemSize.width;
    CGFloat collectionViewWidth = [self collectionViewWidth];
    return -(itemWidth - (collectionViewWidth - itemWidth)/2)/2;
}

-(CGFloat)collectionViewWidth {
    return [UIScreen mainScreen].bounds.size.height;
}


@end
