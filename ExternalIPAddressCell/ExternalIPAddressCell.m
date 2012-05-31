//
//  ExternalIPAddressCell.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExternalIPAddressCell.h"
#import "AFHTTPClient.h"

@implementation ExternalIPAddressCell

@synthesize ipAddressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadIPAddress {
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:IP_URL]];
    
    [client getPath:@"/" 
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *ipAddress = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                NSLog(@"Got IP address %@", ipAddress);
                [self setIPAddress:ipAddress];}
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed to get data");
                [self failedToGetIPAddress];
            }];
}

- (void)setIPAddress:(NSString *)address {
    [ipAddressLabel setText:address];
}

- (void)failedToGetIPAddress {
    [ipAddressLabel setText:@"failed"];
}

@end
