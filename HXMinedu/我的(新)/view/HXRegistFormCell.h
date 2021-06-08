//
//  HXRegistFormCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import "HXRegistFormModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HXRegistFormCell;

@protocol HXRegistFormCellDelegate <NSObject>

-(void)registFormCell:(HXRegistFormCell *)cell downLoadUrl:(NSString *)url;

@end

@interface HXRegistFormCell : UITableViewCell

@property(nonatomic,weak) id<HXRegistFormCellDelegate> delegate;
@property(nonatomic,strong) HXRegistFormModel *registFormModel;

@end

NS_ASSUME_NONNULL_END
