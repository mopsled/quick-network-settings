//
//  InterfaceTableViewController.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterfaceTableViewController.h"
#import "NICInfo.h"
#import "NICInfoSummary.h"

@interface NSArray (AddFirstSelector)
- (id)first;
@end

@implementation NSArray (AddFirstSelector)
- (id)first {
    return [self objectAtIndex:0];
}
@end


@implementation InterfaceTableViewController {
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setInterfaceTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPInfos first];
        [ipAddressLabel setText:info.ip];
    } else if([nicInfo.nicIPv6Infos count] != 0) {
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPv6Infos first];
        [ipAddressLabel setText:info.ip];
    } else {
        [ipAddressLabel setText:@"None"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)refreshAction:(id)sender {
    NICInfoSummary* summary = [[NICInfoSummary alloc] init];
    nicInfos = summary.nicInfos;
    
    [interfaceTableView reloadData];
}
                                
@end
