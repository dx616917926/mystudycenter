//
//  UIDevice+HXDevice.m
//  eplatform-edu
//
//  Created by iMac on 2017/7/19.
//  Copyright © 2017年 华夏大地教育网. All rights reserved.
//

#import "UIDevice+HXDevice.h"
#import <sys/utsname.h>

@implementation UIDevice (HXDevice)

/**
 苹果设备类型对应表
 支持 iPhone系列、iPad系列
 
 @return 设备类型
 */
- (NSString*)deviceModelName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE 2020";
    
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
        
    if ([deviceModel isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    
    if ([deviceModel isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    
    if ([deviceModel isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    
    if ([deviceModel isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    
    //iPod 系列
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 6";
    
    if ([deviceModel isEqualToString:@"iPod9,1"])      return @"iPod Touch 7";
    
    //iPad 系列
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad 1";
    
    if ([deviceModel isEqualToString:@"iPad2,1"]
        ||[deviceModel isEqualToString:@"iPad2,2"]
        ||[deviceModel isEqualToString:@"iPad2,3"]
        ||[deviceModel isEqualToString:@"iPad2,4"])    return @"iPad 2";
    
    if ([deviceModel isEqualToString:@"iPad2,5"]
        ||[deviceModel isEqualToString:@"iPad2,6"]
        ||[deviceModel isEqualToString:@"iPad2,7"])    return @"iPad mini";
    
    if ([deviceModel isEqualToString:@"iPad3,1"]
        ||[deviceModel isEqualToString:@"iPad3,2"]
        ||[deviceModel isEqualToString:@"iPad3,3"])    return @"iPad 3";
    
    if ([deviceModel isEqualToString:@"iPad3,4"]
        ||[deviceModel isEqualToString:@"iPad3,5"]
        ||[deviceModel isEqualToString:@"iPad3,6"])    return @"iPad 4";
    
    if ([deviceModel isEqualToString:@"iPad4,1"]
        ||[deviceModel isEqualToString:@"iPad4,2"]
        ||[deviceModel isEqualToString:@"iPad4,3"])    return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad5,3"]
        ||[deviceModel isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad11,3"]
        ||[deviceModel isEqualToString:@"iPad11,4"])   return @"iPad Air 3";
    
    if ([deviceModel isEqualToString:@"iPad6,11"]
        ||[deviceModel isEqualToString:@"iPad6,12"])   return @"iPad 5";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    
    if ([deviceModel isEqualToString:@"iPad5,1"]
        ||[deviceModel isEqualToString:@"iPad5,2"])    return @"iPad mini 4";
    
    if ([deviceModel isEqualToString:@"iPad11,1"]
        ||[deviceModel isEqualToString:@"iPad11,2"])   return @"iPad mini 5";
    
    if ([deviceModel isEqualToString:@"iPad14,1"]
        ||[deviceModel isEqualToString:@"iPad14,2"])   return @"iPad mini 6";
    
    if ([deviceModel isEqualToString:@"iPad6,7"]
        ||[deviceModel isEqualToString:@"iPad6,8"])    return @"iPad Pro (12.9-inch)";
    
    if ([deviceModel isEqualToString:@"iPad7,1"]
        ||[deviceModel isEqualToString:@"iPad7,2"])    return @"iPad Pro 2 (12.9-inch)";
    
    if ([deviceModel isEqualToString:@"iPad7,3"]
        ||[deviceModel isEqualToString:@"iPad7,4"])    return @"iPad Pro (10.5-inch)";
    
    if ([deviceModel isEqualToString:@"iPad6,3"]
        ||[deviceModel isEqualToString:@"iPad6,4"])    return @"iPad Pro (9.7-inch)";
    
    if ([deviceModel isEqualToString:@"iPad7,5"]
        ||[deviceModel isEqualToString:@"iPad7,6"])    return @"iPad 6";
    
    if ([deviceModel isEqualToString:@"iPad8,1"]
        ||[deviceModel isEqualToString:@"iPad8,2"]
        ||[deviceModel isEqualToString:@"iPad8,3"]
        ||[deviceModel isEqualToString:@"iPad8,4"])    return @"iPad Pro (11-inch)(1rd generation)";
    
    if ([deviceModel isEqualToString:@"iPad8,5"]
        ||[deviceModel isEqualToString:@"iPad8,6"]
        ||[deviceModel isEqualToString:@"iPad8,7"]
        ||[deviceModel isEqualToString:@"iPad8,8"])    return @"iPad Pro 3 (12.9-inch)";
    
    if ([deviceModel isEqualToString:@"iPad7,11"]
        ||[deviceModel isEqualToString:@"iPad7,12"])    return @"iPad 7";
    
    if ([deviceModel isEqualToString:@"iPad8,11"]
        ||[deviceModel isEqualToString:@"iPad8,12"])    return @"iPad Pro 4 (12.9-inch)";
    
    if ([deviceModel isEqualToString:@"iPad8,9"]
        ||[deviceModel isEqualToString:@"iPad8,10"])    return @"iPad Pro (11-inch)(2rd generation)";
    
    if ([deviceModel isEqualToString:@"iPad13,1"]
        ||[deviceModel isEqualToString:@"iPad13,2"])    return @"iPad Air 4";
    
    if ([deviceModel isEqualToString:@"iPad11,6"]
        ||[deviceModel isEqualToString:@"iPad11,7"])    return @"iPad 8";
    
    if ([deviceModel isEqualToString:@"iPad12,1"]
        ||[deviceModel isEqualToString:@"iPad12,2"])    return @"iPad 9";
    
    if ([deviceModel isEqualToString:@"iPad13,8"]
        ||[deviceModel isEqualToString:@"iPad13,9"]
        ||[deviceModel isEqualToString:@"iPad13,10"]
        ||[deviceModel isEqualToString:@"iPad13,11"])    return @"iPad Pro (12.9-inch)(5th generation)";
    
    if ([deviceModel isEqualToString:@"iPad13,4"]
        ||[deviceModel isEqualToString:@"iPad13,5"]
        ||[deviceModel isEqualToString:@"iPad13,6"]
        ||[deviceModel isEqualToString:@"iPad13,7"])    return @"iPad Pro (11-inch)(3rd generation)";
    
    return deviceModel;
}

@end
