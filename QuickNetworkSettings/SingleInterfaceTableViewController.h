//
//  SingleInterfaceTableViewController.h
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NICInfo;

@interface SingleInterfaceTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;

@property (weak, nonatomic) IBOutlet UILabel *routerLabel;
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;
@property (weak, nonatomic) IBOutlet UILabel *netmaskLabel;

@property (weak, nonatomic) IBOutlet UILabel *externalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dnsLabel;


@property (weak, nonatomic) NICInfo *nicInfo;


@end
