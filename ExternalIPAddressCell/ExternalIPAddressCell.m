//
//  ExternalIPAddressCell.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExternalIPAddressCell.h"
#import "AFHTTPClient.h"

#define ANIMATION_DURATION 0.5

@implementation ExternalIPAddressCell

@synthesize ipAddressLabel;
@synthesize activityIndicator;
@synthesize retryButton;

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
    ipAddressLabel.alpha = 0.0;
    retryButton.alpha = 0.0;
    
    activityIndicator.alpha = 1.0;
    [activityIndicator startAnimating];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:IP_URL]];
    
    [client getPath:@"/" 
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *ipAddress = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                NSLog(@"Got IP address %@", ipAddress);
                [self setIPAddress:ipAddress];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed to get data");
                [self failedToGetIPAddress];
            }];
}

- (void)setIPAddress:(NSString *)address {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        
        [ipAddressLabel setText:address];
        
        [UIView animateWithDuration:ANIMATION_DURATION 
                         animations:^{
                             activityIndicator.alpha = 0.0;
                             ipAddressLabel.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [activityIndicator stopAnimating];
                         }];
    });
}

- (void)failedToGetIPAddress {
    [UIView animateWithDuration:ANIMATION_DURATION 
                     animations:^{
                         activityIndicator.alpha = 0.0;
                         retryButton.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [activityIndicator stopAnimating];
                     }];
}
     
 - (IBAction)retryButtonAction:(id)sender {
     [self loadIPAddress];
 }

@end
