//
//  HXHomePageGuideCell.h
//  HXMinedu
//
//  Created by mac on 2021/5/20.
//

#import <UIKit/UIKit.h>
#import "HXColumnItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXHomePageGuideCell : UITableViewCell
@property (nonatomic, strong) HXColumnItemModel *columnItemModel;

@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
