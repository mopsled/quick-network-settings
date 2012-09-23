//
//  ExternalIPAddressCell.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/30/12.
//  Copyright (c) 2012 Alec Geatches. All rights reserved.
//

#import "ExternalIPAddressCell.h"
#import "AFHTTPRequestOperation.h"
#import "NSArray+Map.h"

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

- (void)loadIPAddress {
    ipAddressLabel.alpha = 0.0;
    retryButton.alpha = 0.0;
    
    activityIndicator.alpha = 1.0;
    [activityIndicator startAnimating];
    
    NSArray *ipUrlStrings = [self getExternalIpUrls];
    __block AFHTTPRequestOperation *previousOperation = nil;
    NSArray *ipRequestOperations = [ipUrlStrings mapObjectsUsingBlock:^id(NSString *urlString, NSUInteger idx) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFHTTPRequestOperation *httpOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        if (previousOperation) {
            [httpOperation addDependency:previousOperation];
        }
        
        previousOperation = httpOperation;
        return httpOperation;
    }];
    
    void (^success)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *thisOperation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9a-f]+[:.])+[0-9a-f]+" options:0 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:response options:0 range:NSMakeRange(0, [response length])];
        
        if(match) {
            NSRange matchRange = [match range];
            NSString *ipAddress = [response substringWithRange:matchRange];
            [self setIPAddress:ipAddress];
            
            for (AFHTTPRequestOperation *operation in ipRequestOperations) {
                if (operation != thisOperation) {
                    [operation cancel];
                }
            }
        }
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedToGetIPAddress];
    };
    
    for (AFHTTPRequestOperation *operation in ipRequestOperations) {
        [operation setCompletionBlockWithSuccess:success failure:nil];
    }
    AFHTTPRequestOperation *lastRequest = [ipRequestOperations lastObject];
    [lastRequest setCompletionBlockWithSuccess:success failure:failure];
    
    [[NSOperationQueue mainQueue] addOperations:ipRequestOperations waitUntilFinished:NO];
}

- (NSArray *)getExternalIpUrls {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"IpUrls" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:plistPath];
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
     [self loadIPAddress];
 }

@end
