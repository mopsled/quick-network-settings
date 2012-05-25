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

@implementation InterfacesTableViewController {
    NSArray *nicInfos;
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
    
    [self refreshInterfaceData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return [nicInfos count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InterfaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NICInfo *nicInfo = [nicInfos objectAtIndex:indexPath.row];
    
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
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Application logic

- (void)refreshInterfaceData {
    NICInfoSummary* summary = [[NICInfoSummary alloc] init];
    nicInfos = summary.nicInfos;
    
    [interfaceTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)refreshAction:(id)sender {
    [self refreshInterfaceData];
}

#pragma mark - Storyboard logic

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SelectInterface"]) {
		SingleInterfaceTableViewController *interfaceViewController = segue.destinationViewController;
        interfaceViewController.nicInfo = [nicInfos objectAtIndex:[interfaceTableView indexPathForSelectedRow].row];
	}
}
                                
@end
