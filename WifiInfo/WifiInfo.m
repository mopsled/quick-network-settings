//
//  WifiInfo.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WifiInfo.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation WifiInfo

+ (id)fetchSSIDInfo {
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

@end
