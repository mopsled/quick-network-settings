//
//  ExternalIPAddressCell.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/30/12.
//  Copyright (c) 2012 Alec Geatches. All rights reserved.
//

#import "GatewayCell.h"

#define ANIMATION_DURATION 0.5

@implementation GatewayCell {
    SimplePing *simplePing;
}

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

- (void)loadGateway {
    ipAddressLabel.alpha = 0.0;
    retryButton.alpha = 0.0;
    
    activityIndicator.alpha = 1.0;
    [activityIndicator startAnimating];
    
    simplePing = [SimplePing simplePingWithHostName:@"google.com"];
    [simplePing setTtl:1];
    [simplePing setDelegate:self];
    [simplePing start];
}

- (BOOL)hasCopyableInformation {
    return (ipAddressLabel.alpha == 1.0);
}

- (NSString *)ipAddress {
    return [ipAddressLabel text];
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
                             [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
                         }];
    });
}

- (void)failedToGetIPAddress {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
    [self loadGateway];
}


- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    [pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    [simplePing stop];
    [self failedToGetIPAddress];
}

// Called whenever the SimplePing object has successfully sent a ping packet. 
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet {
    
}

// Called whenever the SimplePing object tries and fails to send a ping packet.
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error {
    [simplePing stop];
     [self failedToGetIPAddress];
}

// Called whenever the SimplePing object receives an ICMP packet that looks like 
// a response to one of our pings (that is, has a valid ICMP checksum, has 
// an identifier that matches our identifier, and has a sequence number in 
// the range of sequence numbers that we've sent out).
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    [simplePing stop];
}

// Called whenever the SimplePing object receives an ICMP packet that does not 
// look like a response to one of our pings.
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    [simplePing stop];
    
    IPHeader *header = (IPHeader *)[packet bytes];
    
    NSString *ipAddress = [[NSString alloc] initWithFormat:@"%d.%d.%d.%d", header->sourceAddress[0], header->sourceAddress[1], header->sourceAddress[2], header->sourceAddress[3]];
    
    [self setIPAddress:ipAddress];
}

@end
