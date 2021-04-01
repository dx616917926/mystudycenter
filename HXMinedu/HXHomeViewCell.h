//
//  HXHomeViewCell.h
//  HXMinedu
//
//  Created by Mac on 2020/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXHomeViewCell : UITableViewCell

@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, weak) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
