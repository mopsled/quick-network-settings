//
//  InterfaceTableViewController.h
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterfaceTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *interfaceTableView;

- (IBAction)refreshAction:(id)sender;

@end
