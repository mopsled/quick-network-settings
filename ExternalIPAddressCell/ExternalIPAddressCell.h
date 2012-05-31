//
//  ExternalIPAddressCell.h
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IP_URL @"http://whatismyip.akamai.com"

@interface ExternalIPAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;

- (void)loadIPAddress;

@end
