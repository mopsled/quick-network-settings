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
@synthesize broadcastLabel;
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
    
    [macLabel setText:[[nicInfo macAddressWithSeparator:@":"] lowercaseString]];
}

- (void)viewDidUnload {
    [self setIpAddressLabel:nil];
    [self setNetmaskLabel:nil];
    [self setMacLabel:nil];
    [self setBroadcastLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [pasteBoard setString:[ipAddressLabel text]];
        } else if(indexPath.row == 1) {
            [pasteBoard setString:[macLabel text]];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [pasteBoard setString:[broadcastLabel text]];
        } else if(indexPath.row == 1) {
            [pasteBoard setString:[netmaskLabel text]];
        }
    }
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    if(action != @selector(copy:)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
