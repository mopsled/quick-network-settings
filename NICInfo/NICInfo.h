//
//  NICInfo
//
//  Class for getting network interfaces address information instantly.
//  Refer to showNICInfo method of ViewController for USAGE.
//
//  Copyrights - USE FREELY, CAUSE I GOT FREELY.
//
//
//  AUTHOR          : kenial (keniallee@gmail.com)
//  CREATED ON      : 2011/11/19
//  UPDATED ON      : 2011/12/31
//

#import <Foundation/Foundation.h>


@interface NICInfo : NSObject {
    NSString*           interfaceName;
    NSString*           macAddress;
    NSMutableArray*     nicIPInfos;
    NSMutableArray*     nicIPv6Infos;
}

@property (copy)        NSString*       interfaceName;
@property (copy)        NSString*       macAddress;
@property (retain)      NSMutableArray* nicIPInfos;
@property (retain)      NSMutableArray* nicIPv6Infos;


// If non-'FF:FF:FF:FF:FF:FF' format MAC address is needed, use this method
- (NSString *)macAddressWithSeparator:(NSString*)separator;
- (NSString *)bestAddress;

+ (NSArray*)nicInfos;

@end





// Depicts a specific ip address and its netmask, broadcast ip
// This class represents both IPv4 and IPv6 info. 
@interface NICIPInfo : NSObject {
    NSString*   ip;
    NSString*   netmask;
    NSString*   broadcastIP;
}

@property (retain)     NSString*   ip;
@property (retain)     NSString*   netmask;
@property (retain)     NSString*   broadcastIP;
@end

