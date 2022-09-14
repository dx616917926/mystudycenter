//
//  HXCommentModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCommentModel : NSObject

///授课风格
@property(nonatomic, strong) NSString *SkfgSatisfactionScore;
///授课内容
@property(nonatomic, strong) NSString *SknrSatisfactionScore;
///直播体验
@property(nonatomic, strong) NSString *ZbtySatisfactionScore;
///其他建议
@property(nonatomic, strong) NSString *Suggestion;

@end

NS_ASSUME_NONNULL_END
