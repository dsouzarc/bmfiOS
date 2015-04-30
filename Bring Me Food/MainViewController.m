//
//  MainViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) CreateOrderViewController *createOrderVC;
@property (strong, nonatomic) LatestOrderViewController *latestOrderVC;
@property (strong, nonatomic) ExistingOrdersViewController *existingOrderVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.createOrderVC = [[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:[NSBundle mainBundle]];
        self.latestOrderVC = [[LatestOrderViewController alloc] initWithNibName:@"LatestOrderViewController" bundle:[NSBundle mainBundle]];
        self.existingOrderVC = [[ExistingOrdersViewController alloc] initWithNibName:@"ExistingOrderViewController" bundle:[NSBundle mainBundle]];
    }
    
    return self;
}

@end
