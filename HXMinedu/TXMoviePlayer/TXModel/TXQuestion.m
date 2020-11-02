//
//  TXQuestion.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/22.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXQuestion.h"

@implementation TXQuestion

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"optionList" : @"TXQuestionOption"
             };
}

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSMutableString *answer = [NSMutableString string];
    for (TXQuestionOption *option in self.optionList) {
        if (option.correct) {
            [answer appendString:option.quesValue];
        }
    }
    self.answer = answer;
}

@end
