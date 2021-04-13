//
//  HXMessageObject.h
//  HXMinedu
//
//  Created by Mac on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXMessageObject : NSObject

@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *redirectURL;//消息H5地址
@property(nonatomic, strong) NSString *message_id;
@property(nonatomic, strong) NSString *MessageTitle;
@property(nonatomic, strong) NSString *sendTime;
@property(nonatomic, strong) NSString *statusID;      //0是未读  1是已读

@end

NS_ASSUME_NONNULL_END
