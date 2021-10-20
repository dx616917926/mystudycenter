//
//  HXLiveBroadcastModel.h
//  HXMinedu
//
//  Created by mac on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXLiveBroadcastModel : NSObject
///直播名称
@property(nonatomic, strong) NSString *liveName;
///直播内容
@property(nonatomic, strong) NSString *liveContent;
///直播人
@property(nonatomic, strong) NSString *liveUser;
///H5直播地址
@property(nonatomic, strong) NSString *liveUrl;
///直播封面
@property(nonatomic, strong) NSString *imgUrl;
///房间号
@property(nonatomic, strong) NSString *roomNumber;
///开始时间
@property(nonatomic, strong) NSString *liveStartDateText;
@property(nonatomic, strong) NSString *liveStartDate;
///结束时候
@property(nonatomic, strong) NSString *liveEndDateText;
@property(nonatomic, strong) NSString *liveEndDate;
///是否在直播中 1是0否
@property(nonatomic, assign) NSInteger isLive;

@end

NS_ASSUME_NONNULL_END
