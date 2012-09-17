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

@property (weak, nonatomic) IBOutlet UILabel *macLabel;

@property (weak, nonatomic) IBOutlet UILabel *ipv4AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipv4BroadcastLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipv4NetmaskLabel;

@property (weak, nonatomic) IBOutlet UILabel *ipv6AddressLabel;

@property (weak, nonatomic) NICInfo *nicInfo;


@end
