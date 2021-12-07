//
//  HXCommonSelectModel.m
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import "HXCommonSelectModel.h"

@implementation HXCommonSelectModel

-(NSString *)content{
    if (![HXCommonUtil isNull:self.versionName]) {
        return self.versionName;
    }else if(![HXCommonUtil isNull:self.name]){
        return self.name;
    }else if(![HXCommonUtil isNull:self.province]){
        return self.province;
    }else if(![HXCommonUtil isNull:self.enterDate]){
        return self.enterDate;
    }else if(![HXCommonUtil isNull:self.BkSchool]){
        return self.BkSchool;
    }else if(![HXCommonUtil isNull:self.studyTypeName]){
        return self.studyTypeName;
    }else if(![HXCommonUtil isNull:self.majorLongName]){
        return self.majorLongName;
    }else if(![HXCommonUtil isNull:self.orgName]){
        return self.orgName;
    }else if(![HXCommonUtil isNull:self.sourceName]){
        return self.sourceName;
    }else if(![HXCommonUtil isNull:self.text]){
        return self.text;
    }else{
        return _content;
    }
}

@end
