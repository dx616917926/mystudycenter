//
//  HXSelectCourseCell.h
//  HXMinedu
//
//  Created by mac on 2022/2/15.
//

#import <UIKit/UIKit.h>
#import "HXCourseLearnCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HXSelectCourseCellDelegate <NSObject>

@property(nonatomic,weak) id<HXSelectCourseCellDelegate> delegate;

-(void)handleItem:(HXModelItem *)item;

@end

@interface HXSelectCourseCell : UITableViewCell

@property(nonatomic,weak) id<HXSelectCourseCellDelegate> delegate;

@property(nonatomic,assign) HXClickType type;

@property(nonatomic,strong) HXCourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
