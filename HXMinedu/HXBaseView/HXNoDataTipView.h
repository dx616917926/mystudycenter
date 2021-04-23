//
//  HXNoDataTipView.h
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXNoDataTipView : UIView

@property(nonatomic,strong) UIImage *tipImage;
@property(nonatomic,strong) NSString *tipTitle;
@property(nonatomic,assign) NSInteger tipImageViewOffset;

@end

NS_ASSUME_NONNULL_END
