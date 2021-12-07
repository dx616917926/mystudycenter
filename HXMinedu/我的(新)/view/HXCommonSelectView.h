//
//  HXCommonSelectView.h
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import <UIKit/UIKit.h>
#import "HXCommonSelectCell.h"
#import "HXCommonSelectModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SeletConfirmBlock)(HXCommonSelectModel *selectModel);

@interface HXCommonSelectView : UIView
///数据源
@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,assign) NSInteger selectNum;

@property(nonatomic,strong) NSString *title;
///
@property(nonatomic,strong) NSString *spacialTitle;

@property(nonatomic,copy) SeletConfirmBlock seletConfirmBlock;

-(void)show;

@end

NS_ASSUME_NONNULL_END
