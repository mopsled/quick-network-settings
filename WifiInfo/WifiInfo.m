//
//  WifiInfo.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WifiInfo.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@interface WifiInfo(Private)

+ (NSString *)padHexString:(NSString *)hexString;

@end

@implementation WifiInfo

+ (id)fetchSSIDInfo {
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    if(info) {
        NSMutableDictionary *infoDictionary = [(NSDictionary *)info mutableCopy];
        if([infoDictionary objectForKey:@"BSSID"]) {
            [infoDictionary setValue:[WifiInfo padHexString:[infoDictionary objectForKey:@"BSSID"]] forKey:@"BSSID"];
            return infoDictionary;
        }
    }
    
    return info;
}

+ (NSString *)padHexString:(NSString *)hex {
    NSArray *hexStringArray = [hex componentsSeparatedByString:@":"];
    NSMutableArray *paddedHexStringArray = [[NSMutableArray alloc] init];
    
    for (NSString *hexString in hexStringArray) {
        [paddedHexStringArray addObject:[[NSString stringWithFormat:@"%2s", [hexString UTF8String]] stringByReplacingOccurrencesOfString:@" " withString:@"0"]];
    }
    
    return [paddedHexStringArray componentsJoinedByString:@":"];
}
    
@end
