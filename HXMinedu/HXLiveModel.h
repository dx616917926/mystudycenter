//
//  HXLiveModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/21.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLiveModel : NSObject

@property(nonatomic, strong) NSString *liveName;       //直播名称
@property(nonatomic, strong) NSString *liveContent;    //直播内容
@property(nonatomic, strong) NSString *liveUser;       //直播主讲人
@property(nonatomic, strong) NSString *liveStartDate;  //直播开始时间
@property(nonatomic, strong) NSString *liveEndDate;    //直播结束时间
@property(nonatomic, strong) NSString *liveUrl;        //直播地址

@end

NS_ASSUME_NONNULL_END
