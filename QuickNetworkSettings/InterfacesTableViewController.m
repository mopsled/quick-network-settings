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

@implementation InterfacesTableViewController {
    NSArray *interfaces;
    NSDictionary *wifiInfo;
    ExternalIPAddressCell *externalIPCell;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [interfaces count];
        case 1:
            return 3;
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
        
        if([nicInfo.nicIPInfos count] != 0) {
            NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPInfos objectAtIndex:0];
            [ipAddressLabel setText:info.ip];
        } else if([nicInfo.nicIPv6Infos count] != 0) {
            NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPv6Infos objectAtIndex:0];
            [ipAddressLabel setText:info.ip];
        } else {
            [ipAddressLabel setText:@"none"];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            CellIdentifier = @"SSIDCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            UILabel *ssidLabel = (UILabel *)[cell viewWithTag:100];
            
            NSString *ssid = [wifiInfo objectForKey:@"SSID"];
            
            if(ssid) {
                [ssidLabel setText:ssid];
            } else {
                [ssidLabel setText:@"Not connected"];
            }
            
        } else if(indexPath.row == 1) {
            NSString *CellIdentifier = @"BSSIDCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            UILabel *bssidLabel = (UILabel *)[cell viewWithTag:100];
            
            NSString *bssid = [wifiInfo objectForKey:@"BSSID"];
            
            if(bssid) {
                [bssidLabel setText:bssid];
            } else {
                [bssidLabel setText:@"Not connected"];
            }
            
            
        } else if(indexPath.row == 2) {
            return externalIPCell;
        }
    }
    
    return cell;
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
