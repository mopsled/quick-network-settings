//
//  SingleInterfaceTableViewController.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleInterfaceTableViewController.h"

#import "NICInfo.h"
#import "NICInfoSummary.h"

@interface SingleInterfaceTableViewController ()

@end

@implementation SingleInterfaceTableViewController

@synthesize ipAddressLabel;
@synthesize macLabel;
@synthesize netmaskLabel;
@synthesize routerLabel;
@synthesize broadcastLabel;
@synthesize dnsLabel;
@synthesize nicInfo;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:nicInfo.interfaceName];

    if([nicInfo.nicIPInfos count] != 0) {
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPInfos objectAtIndex:0];
        [ipAddressLabel setText:info.ip];
        [netmaskLabel setText:info.netmask];
        [broadcastLabel setText:info.broadcastIP];
    } else if([nicInfo.nicIPv6Infos count] != 0) {
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPv6Infos objectAtIndex:0];
        [ipAddressLabel setText:info.ip];
        [netmaskLabel setText:info.netmask];
        [broadcastLabel setText:info.broadcastIP];
    } else {
        [ipAddressLabel setText:@"none"];
        [netmaskLabel setText:@"none"];
    }
    
    [macLabel setText:[[nicInfo getMacAddressWithSeparator:@":"] lowercaseString]];
}

- (void)viewDidUnload {
    [self setIpAddressLabel:nil];
    [self setNetmaskLabel:nil];
    [self setRouterLabel:nil];
    [self setDnsLabel:nil];
    [self setMacLabel:nil];
    [self setBroadcastLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
