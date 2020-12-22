//
//  HXMajorModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXMajorModel : NSObject

@property(nonatomic, strong) NSString *major_id;        //专业ID
@property(nonatomic, strong) NSString *majorName;       //专业名称
@property(nonatomic, strong) NSString *educationName;   //层次

@end

NS_ASSUME_NONNULL_END
