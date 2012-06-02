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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

- (IBAction)retryButtonAction:(id)sender;

- (void)loadIPAddress;
- (BOOL)hasCopyableInformation;
- (NSString *)ipAddress;

@end