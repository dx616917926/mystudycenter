//
//  HXCycleScrollViewFlowLayout.h
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//


#import "HXCycleScrollViewFlowLayout.h"

@implementation HXCycleScrollViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        
        _zoomScale = 1.f;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        _zoomScale = 1.f;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            CGFloat offset = CGRectGetMidY(self.collectionView.bounds);
            CGFloat distanceForScale = self.itemSize.height + self.minimumLineSpacing;
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat scale = 0.f;
                CGFloat distance = ABS(offset - attr.center.y);
                if (distance >= distanceForScale) {
                    scale = _zoomScale;
                } else if (distance == 0.f) {
                    scale = 1.f;
                    attr.zIndex = 1;
                } else {
                    scale = _zoomScale + (distanceForScale - distance) * (1.f - _zoomScale) / distanceForScale;
                }
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
        default: {
            CGFloat offset = CGRectGetMidX(self.collectionView.bounds);
            CGFloat distanceForScale = self.itemSize.width + self.minimumLineSpacing;
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat scale = 0.f;
                CGFloat distance = ABS(offset - attr.center.x);
                if (distance >= distanceForScale) {
                    scale = _zoomScale;
                } else if (distance == 0.f) {
                    scale = 1.f;
                    attr.zIndex = 1;
                } else {
                    scale = _zoomScale + (distanceForScale - distance) * (1.f - _zoomScale) / distanceForScale;
                }
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
    }
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            // 计算出最终显示的矩形框
            CGRect rect;
            rect.origin.x = 0.f;
            rect.origin.y = proposedContentOffset.y;
            rect.size = self.collectionView.frame.size;
            
            // 计算collectionView最中心点的y值
            CGFloat centerY = proposedContentOffset.y + self.collectionView.frame.size.height * 0.5;
            
            // 存放最小的间距值
            CGFloat minDelta = MAXFLOAT;
            // 获得super已经计算好的布局属性
            NSArray *array = [super layoutAttributesForElementsInRect:rect];
            
            for (UICollectionViewLayoutAttributes *attrs in array) {
                if (ABS(minDelta) > ABS(attrs.center.y - centerY)) {
                    minDelta = attrs.center.y - centerY;
                }
            }
            // 修改原有的偏移量
            proposedContentOffset.y += minDelta;
            break;
        }
        default: {
            // 计算出最终显示的矩形框
            CGRect rect;
            rect.origin.y = 0.f;
            rect.origin.x = proposedContentOffset.x;
            rect.size = self.collectionView.frame.size;
            
            // 计算collectionView最中心点的x值
            CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
            
            // 存放最小的间距值
            CGFloat minDelta = MAXFLOAT;
            // 获得super已经计算好的布局属性
            NSArray *array = [super layoutAttributesForElementsInRect:rect];
            
            for (UICollectionViewLayoutAttributes *attrs in array) {
                if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
                    minDelta = attrs.center.x - centerX;
                }
            }
            // 修改原有的偏移量
            proposedContentOffset.x += minDelta;
            break;
        }
    }
    return proposedContentOffset;
}

@end
