//
//  HXDateHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXDateHeaderView : UITableViewHeaderFooterView
//是否是第一个和最后一个，用来判断虚线方向，第一个：隐藏向上虚线，最后一个隐藏向下虚线
@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,assign) BOOL isLast;
@end

NS_ASSUME_NONNULL_END
