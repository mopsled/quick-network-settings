//
//  InterfaceTableViewController.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    switch (section) {
        case 0:
            return [interfaces count];
        case 1:
            return 2;
        case 2:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Interfaces";
        case 1:
            return @"Wifi Information";
        case 2:
            return @"Additional Information";
        default:
            return nil;
    }
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
            return gatewayCell;
        } else if(indexPath.row == 1) {
            return externalIPCell;
        }
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        return indexPath;
    }
    
    return nil;
}

-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    
    if(indexPath.section == 0) {
        NICInfo *interface = [interfaces objectAtIndex:indexPath.row];
        [pasteBoard setString:[interface bestAddress]];
    } else if(indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [pasteBoard setString:[wifiInfo objectForKey:@"SSID"]];
                break;
            case 1:
                [pasteBoard setString:[wifiInfo objectForKey:@"BSSID"]];
                break;
        }
    } else if(indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [pasteBoard setString:[gatewayCell ipAddress]];
                break;
            case 1:
                [pasteBoard setString:[externalIPCell ipAddress]];
                break;
        }
    }
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    if(action != @selector(copy:)) {
        return NO;
    }
    
    if(indexPath.section == 0 || indexPath.section == 1) {
        return YES;
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            return [gatewayCell hasCopyableInformation];
        } else if(indexPath.row == 1) {
            return [externalIPCell hasCopyableInformation];
        }
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return YES;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            return ([wifiInfo objectForKey:@"SSID"] != nil);
        } else if(indexPath.row == 1) {
            return ([wifiInfo objectForKey:@"BSSID"] != nil);
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            return [gatewayCell hasCopyableInformation];
        } else if(indexPath.row == 1) {
            return [externalIPCell hasCopyableInformation];
        }
    }
    
    return NO;
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
