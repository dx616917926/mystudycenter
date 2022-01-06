//
//  HXCommonSelectModel.m
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import "HXCommonSelectModel.h"

@implementation HXCommonSelectModel

-(NSString *)content{
    if (![HXCommonUtil isNull:self.majorName]) {
        return self.majorName;
    }else if(![HXCommonUtil isNull:self.text]){
        return self.text;
    }else{
        return _content;
    }
}

@end
