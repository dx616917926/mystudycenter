//
//  HXCourseCell.h
//  HXMinedu
//
//  Created by 邓雄 on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import "HXExamDateSignInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCourseCell : UITableViewCell

//最后一个，隐藏虚线
@property(nonatomic,assign) BOOL isLast;

@property(nonatomic,strong) HXExamDateSignInfoModel *examDateSignInfoModel;

@end

NS_ASSUME_NONNULL_END
