//
//  GatewayCell.h
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/31/12.
//  Copyright (c) 2012 Alec Geatches. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePing.h"

@interface GatewayCell : UITableViewCell <SimplePingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

- (IBAction)retryButtonAction:(id)sender;

- (void)loadGateway;
- (BOOL)hasCopyableInformation;
- (NSString *)ipAddress;

@end
