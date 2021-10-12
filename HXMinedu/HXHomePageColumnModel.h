//
//  HXHomePageColumnModel.h
//  HXMinedu
//
//  Created by mac on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXHomePageColumnModel : NSObject
///栏目Id
@property(nonatomic, strong) NSString *columnId;
///栏目名称
@property(nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
