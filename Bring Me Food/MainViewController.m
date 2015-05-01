//
//  MainViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/30/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) CreateOrderViewController *createOrderVC;
@property (strong, nonatomic) LatestOrderViewController *latestOrderVC;
@property (strong, nonatomic) ExistingOrdersViewController *existingOrderVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.window.rootViewController = self.tabBarController;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.createOrderVC = [[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:[NSBundle mainBundle]];
        self.createOrderVC.tabBarItem.title = @"Create Order";
        
        self.latestOrderVC = [[LatestOrderViewController alloc] initWithNibName:@"LatestOrderViewController" bundle:[NSBundle mainBundle]];
        self.latestOrderVC.tabBarItem.title = @"Last Order";
        
        self.existingOrderVC = [[ExistingOrdersViewController alloc] initWithNibName:@"ExistingOrderViewController" bundle:[NSBundle mainBundle]];
        self.existingOrderVC.tabBarItem.title = @"Recent Orders";
        
        NSArray *tabs = [NSArray arrayWithObjects:self.existingOrderVC, self.latestOrderVC, self.createOrderVC, nil];
        self.tabBarController.viewControllers = tabs;
    }
    
    return self;
}

@end
