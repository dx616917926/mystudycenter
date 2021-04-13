//
//  HXCycleScrollViewFlowLayout.h
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCycleScrollViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat zoomScale; // default 1.f, it ranges from 0.f to 1.f

@end

NS_ASSUME_NONNULL_END
