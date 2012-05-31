//
//  InterfaceTableViewController.h
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterfacesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *interfaceTableView;

- (void)refreshNetworkData;

- (IBAction)refreshAction:(id)sender;

@end
