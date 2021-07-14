//
//  HXCheckMajorInfoCell.h
//  HXMinedu
//
//  Created by mac on 2021/7/7.
//

#import <UIKit/UIKit.h>
#import "HXMajorInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol HXCheckMajorInfoCellDelegate <NSObject>
//isRecent 是否是新专业
-(void)checkDetailsWithRecent:(BOOL)isRecent;

@end


@interface HXCheckMajorInfoCell : UITableViewCell

@property(nonatomic,weak) id<HXCheckMajorInfoCellDelegate> delegate;

@property(nonatomic,strong) HXMajorInfoModel *majorInfoModel;

@end

NS_ASSUME_NONNULL_END
