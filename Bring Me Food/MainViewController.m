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

@property (strong, nonatomic) ChooseRestaurantViewController *chooseRestaurantVC;
@property (strong, nonatomic) LatestOrderViewController *latestOrderVC;
@property (strong, nonatomic) ExistingOrdersViewController *existingOrderVC;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView addSubview:self.tabBarController.view];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        
        self.chooseRestaurantVC = [[ChooseRestaurantViewController alloc] initWithNibName:@"ChooseRestaurantViewController" bundle:[NSBundle mainBundle]];
        self.chooseRestaurantVC.tabBarItem.title = @"Create Order";
        
        self.latestOrderVC = [[LatestOrderViewController alloc] initWithNibName:@"LatestOrderViewController" bundle:[NSBundle mainBundle]];
        self.latestOrderVC.tabBarItem.title = @"Last Order";
        
        self.existingOrderVC = [[ExistingOrdersViewController alloc] initWithNibName:@"ExistingOrdersViewController" bundle:[NSBundle mainBundle]];
        self.existingOrderVC.tabBarItem.title = @"Recent Orders";

        NSArray *tabs = [NSArray arrayWithObjects:self.existingOrderVC, self.latestOrderVC, self.chooseRestaurantVC, nil];
        
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.viewControllers = tabs;
    }
    
    return self;
}

@end
