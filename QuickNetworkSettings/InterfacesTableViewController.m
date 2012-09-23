//
//  InterfaceTableViewController.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 Alec Geatches. All rights reserved.
//

#import "InterfacesTableViewController.h"
#import "SingleInterfaceTableViewController.h"

#import "NICInfo.h"
#import "NICInfoSummary.h"
#import "WifiInfo.h"

#import "ExternalIPAddressCell.h"
#import "GatewayCell.h"

@implementation InterfacesTableViewController {
    NSArray *interfaces;
    NSDictionary *wifiInfo;
    
    ExternalIPAddressCell *externalIPCell;
    GatewayCell *gatewayCell;
}

@synthesize interfaceTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ExternalIPAddressCell" owner:nil options:nil];
    externalIPCell = [topLevelObjects objectAtIndex:0];
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GatewayCell" owner:nil options:nil];
    gatewayCell = [topLevelObjects objectAtIndex:0];
    
    [self refreshNetworkData];
}

- (void)viewDidUnload
{
    [self setInterfaceTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int sectionCounts[] = {[interfaces count], 2, 2};
    return sectionCounts[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sectionHeaders = [NSArray arrayWithObjects:@"Interfaces", @"Wifi Information", @"Additional Information", nil];
    return [sectionHeaders objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *CellIdentifier;
    
    if(indexPath.section == 0) {
        CellIdentifier = @"InterfaceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NICInfo *nicInfo = [interfaces objectAtIndex:indexPath.row];
        
        UILabel *interfaceLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *ipAddressLabel = (UILabel *)[cell viewWithTag:101];
        
        [interfaceLabel setText:nicInfo.interfaceName];
        [ipAddressLabel setText:[nicInfo bestAddress]];
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            CellIdentifier = @"SSIDCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            UILabel *ssidLabel = (UILabel *)[cell viewWithTag:100];
            
            NSString *ssid = [wifiInfo objectForKey:@"SSID"];
            
            if(ssid) {
                [ssidLabel setText:ssid];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            } else {
                [ssidLabel setText:@"Not connected"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
        } else if(indexPath.row == 1) {
            NSString *CellIdentifier = @"BSSIDCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            UILabel *bssidLabel = (UILabel *)[cell viewWithTag:100];
            
            NSString *bssid = [wifiInfo objectForKey:@"BSSID"];
            
            if(bssid) {
                [bssidLabel setText:bssid];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            } else {
                [bssidLabel setText:@"Not connected"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell = gatewayCell;
        } else if(indexPath.row == 1) {
            cell = externalIPCell;
        }
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedPath = nil;
    
    if(indexPath.section == 0) {
        selectedPath = indexPath;
    }
    
    return selectedPath;
}

- (void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copyText = nil;
    
    if(indexPath.section == 0) {
        NICInfo *interface = [interfaces objectAtIndex:indexPath.row];
        copyText = [interface bestAddress];
    } else if(indexPath.section == 1) {
        NSArray *rowTitles = [NSArray arrayWithObjects:@"SSID", @"BSSID", nil];
        copyText = [rowTitles objectAtIndex:indexPath.row];
    } else if(indexPath.section == 2) {
        NSArray *rowAddresses = [NSArray arrayWithObjects:[gatewayCell ipAddress], [externalIPCell ipAddress], nil];
        copyText = [rowAddresses objectAtIndex:indexPath.row];
    }
    
    if (copyText) {
        [pasteBoard setString:copyText];
    }
}

- (BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    if(action != @selector(copy:)) {
        return NO;
    }
    
    BOOL canCopy = YES;
    
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            canCopy = [gatewayCell hasCopyableInformation];
        } else if(indexPath.row == 1) {
            canCopy = [externalIPCell hasCopyableInformation];
        }
    }
    
    return canCopy;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldShowMenu = NO;
    
    if(indexPath.section == 0) {
        shouldShowMenu = YES;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            shouldShowMenu = ([wifiInfo objectForKey:@"SSID"] != nil);
        } else if(indexPath.row == 1) {
            shouldShowMenu = ([wifiInfo objectForKey:@"BSSID"] != nil);
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            shouldShowMenu = [gatewayCell hasCopyableInformation];
        } else if(indexPath.row == 1) {
            shouldShowMenu = [externalIPCell hasCopyableInformation];
        }
    }
    
    return shouldShowMenu;
}

#pragma mark - Application logic

- (void)refreshNetworkData {
    NICInfoSummary* summary = [[NICInfoSummary alloc] init];
    
    NSMutableArray *usefulInterfaces = [[NSMutableArray alloc] init];
    
    for (NICInfo *nicInfo in summary.nicInfos) {
        if([nicInfo.nicIPInfos count] != 0 || [nicInfo.nicIPv6Infos count] != 0) {
            [usefulInterfaces addObject:nicInfo];
        }
    }
    
    interfaces = usefulInterfaces;
    
    wifiInfo = [WifiInfo fetchSSIDInfo];
    
    [externalIPCell loadIPAddress];
    [gatewayCell loadGateway];
    
    [interfaceTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)refreshAction:(id)sender {
    [self refreshNetworkData];
}

#pragma mark - Storyboard logic

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SelectInterface"]) {
		SingleInterfaceTableViewController *interfaceViewController = segue.destinationViewController;
        interfaceViewController.nicInfo = [interfaces objectAtIndex:[interfaceTableView indexPathForSelectedRow].row];
	}
}
                                
@end
