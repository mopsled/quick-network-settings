#import "NICInfoSummary.h"

@implementation NICInfoSummary


- (void)dealloc
{
    if(nicInfos != nil)
        [nicInfos release];
    [super dealloc];
}

- (NSArray*)nicInfos
{
    if(nicInfos == nil)
        nicInfos = [[NICInfo nicInfos] retain];
    return nicInfos;
}

- (NICInfo*)findNICInfo:(NSString*)interface_name
{
    for(int i=0; i<self.nicInfos.count; i++)
    {
        NICInfo* nic_info = [self.nicInfos objectAtIndex:i];
        if([nic_info.interfaceName isEqualToString:interface_name])
            return nic_info;
    }
    return nil;
}

- (bool)isWifiConnected
{
    NICInfo* nic_info = nil;
    nic_info = [self findNICInfo:@"en0"];
    if(nic_info != nil)
    {
        if(nic_info.nicIPInfos.count > 0)
            return YES;
    }
    return NO;
}

- (bool)isWifiConnectedToNAT
{
    NICInfo* nic_info = nil;
    nic_info = [self findNICInfo:@"en0"];
    if(nic_info != nil)
    {
        for(int i=0; i<nic_info.nicIPInfos.count; i++)
        {
            NICIPInfo* ip_info = [nic_info.nicIPInfos objectAtIndex:i];
            NSRange range = [ip_info.ip rangeOfString:@"192.168"];
            if(range.location == 0)
                return YES;
        }
    }
    return NO;
}

- (bool)isBluetoothConnected
{
    NICInfo* nic_info = nil;
    nic_info = [self findNICInfo:@"en2"];
    if(nic_info != nil)
    {
        if(nic_info.nicIPInfos.count > 0)
            return YES;
    }
    return NO;
}

- (bool)isPersonalHotspotActivated
{
    NICInfo* nic_info = nil;
    nic_info = [self findNICInfo:@"bridge0"];
    if(nic_info != nil)
    {
        if(nic_info.nicIPInfos.count > 0)
            return YES;
    }
    return NO;
}

- (bool)is3GConnected
{
    NICInfo* nic_info = nil;
    nic_info = [self findNICInfo:@"pdp_ip0"];
    if(nic_info != nil)
    {
        if(nic_info.nicIPInfos.count > 0)
            return YES;
    }
    return NO;
}

@end
