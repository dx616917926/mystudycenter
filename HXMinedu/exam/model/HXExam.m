//
//  HXExam.m
//  eplatform-edu
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import "HXExam.h"

@implementation HXExam

-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        if(dictionary)
        {
            _examTitle = [dictionary stringValueForKey:@"examTitle"];
            _leftExamNum = [dictionary stringValueForKey:@"leftExamNum"];
            _examId = [dictionary stringValueForKey:@"examId"];
            _maxExamNum = [dictionary stringValueForKey:@"maxExamNum"];
            _beginTime = [self getDateTimeString:[dictionary objectForKey:@"beginTime"]];
            _endTime = [self getDateTimeString:[dictionary objectForKey:@"endTime"]];
            _allowSeeResult = [dictionary boolValueForKey:@"allowSeeResult"];
            _confuseOrder = [dictionary boolValueForKey:@"confuseOrder"];
            _scoreSecret = [dictionary boolValueForKey:@"scoreSecret"];
            _allowSeeAnswer = [dictionary boolValueForKey:@"allowSeeAnswer"];
            _clientJudge = [dictionary boolValueForKey:@"clientJudge"];
            _allowSeeAnswerOnContinue = [dictionary boolValueForKey:@"allowSeeAnswerOnContinue"];
            _canExam = [dictionary boolValueForKey:@"canExam"];
        }
    }
    return self;
}

-(NSString *)getDateTimeString:(id)str
{
    if ([str isKindOfClass:[NSNumber class]]) {
        
        NSDate * beginTime = [NSDate dateWithTimeIntervalSince1970:[str longLongValue]/1000];
        return [self timeString:beginTime];
    }
    
    return @"";
}

- (NSString *)timeString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *ret = [formatter stringFromDate:date];
    
    return ret;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.examTitle forKey:@"examTitle"];
    [aCoder encodeObject:self.leftExamNum forKey:@"leftExamNum"];
    [aCoder encodeObject:self.examId forKey:@"examId"];
    [aCoder encodeObject:self.maxExamNum forKey:@"maxExamNum"];
    [aCoder encodeObject:self.beginTime forKey:@"beginTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeBool:self.allowSeeResult forKey:@"allowSeeResult"];
    [aCoder encodeBool:self.confuseOrder forKey:@"confuseOrder"];
    [aCoder encodeBool:self.scoreSecret forKey:@"scoreSecret"];
    [aCoder encodeBool:self.allowSeeAnswer forKey:@"allowSeeAnswer"];
    [aCoder encodeBool:self.clientJudge forKey:@"clientJudge"];
    [aCoder encodeBool:self.allowSeeAnswerOnContinue forKey:@"allowSeeAnswerOnContinue"];
    [aCoder encodeBool:self.canExam forKey:@"canExam"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.examTitle = [aDecoder decodeObjectForKey:@"examTitle"];
        self.leftExamNum = [aDecoder decodeObjectForKey:@"leftExamNum"];
        self.examId = [aDecoder decodeObjectForKey:@"examId"];
        self.maxExamNum = [aDecoder decodeObjectForKey:@"maxExamNum"];
        self.beginTime = [aDecoder decodeObjectForKey:@"beginTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.allowSeeResult = [aDecoder decodeBoolForKey:@"allowSeeResult"];
        self.confuseOrder = [aDecoder decodeBoolForKey:@"confuseOrder"];
        self.scoreSecret = [aDecoder decodeBoolForKey:@"scoreSecret"];
        self.allowSeeAnswer = [aDecoder decodeBoolForKey:@"allowSeeAnswer"];
        self.clientJudge = [aDecoder decodeBoolForKey:@"clientJudge"];
        self.allowSeeAnswerOnContinue = [aDecoder decodeBoolForKey:@"allowSeeAnswerOnContinue"];
        self.canExam = [aDecoder decodeBoolForKey:@"canExam"];
    }
    return self;
}

@end
