//
//  TXBitrateItemHelper.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import "TXBitrateItemHelper.h"


@implementation TXBitrateItemHelper

+ (NSArray *)sortWithBitrate:(NSArray*)tracks {

    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:tracks.count];
    
    NSArray *sortRuleArray = @[@"SQ",@"HQ",@"FD",@"LD",@"SD",@"HD",@"2K",@"4K",@"OD"];
    for (NSString *sortStr in sortRuleArray) {
        for (AVPTrackInfo *info in tracks) {
            if ([info.trackDefinition isEqualToString:sortStr]) {
                NSString *str = [self qualityFromTrackDefinition:info.trackDefinition];
                [retArray addObject:str];
                break;
            }
        }
    }

    return retArray;
}

+ (NSArray<NSString *> *)allQualities {
    return @[@"流畅",@"超清",@"标清",@"原画",@"高清",@"2K",@"4K",@"原画",@"低音质",@"高音质"];
}

+ (NSString *)qualityFromTrackDefinition:(NSString *)definition {
    
    NSArray *array = @[@"FD",@"HD",@"LD",@"OD",@"SD",@"2K",@"4K",@"SQ",@"HQ"];
    NSInteger index = [array indexOfObject:definition];
    NSArray *titles = [self allQualities];
    NSString * nameStr = [titles objectAtIndex:index];
    return nameStr;
}

@end
