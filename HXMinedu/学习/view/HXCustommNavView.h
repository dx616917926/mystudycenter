//
//  HXCustommNavView.h
//  HXMinedu
//
//  Created by mac on 2021/3/26.
//

#import <UIKit/UIKit.h>
#import "HXVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectTypeCallBack)(void);

@interface HXCustommNavView : UIView

@property(nonatomic,copy) SelectTypeCallBack selectTypeCallBack;
@property(nonatomic,strong) HXVersionModel *selectVersionModel;

@end

NS_ASSUME_NONNULL_END
