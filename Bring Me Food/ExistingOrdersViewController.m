//
//  ExistingOrdersViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/28/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ExistingOrdersViewController.h"

@interface ExistingOrdersViewController ()
- (IBAction)createNewOrder:(id)sender;

@end

@implementation ExistingOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)createNewOrder:(id)sender {
    
}
@end
