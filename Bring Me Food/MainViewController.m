//
//  MainViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/1/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"
#import "NewOrderViewController.h"
#import "ExistingOrdersViewController.h"

@interface MainViewController () <UITabBarControllerDelegate>

@property (nonatomic, retain) UIWindow * window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@property (nonatomic, strong) NewOrderViewController *_newOrderViewController;
@property (nonatomic, strong) ExistingOrdersViewController *_existingOrdersViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [self initializeTabBarItems];
    self.window.rootViewController = self.tabBarController;
    
}

- (NSArray*) initializeTabBarItems
{
    self._newOrderViewController = [[NewOrderViewController alloc]
                                        initWithNibName:@"NewOrderViewController" bundle:nil];
    self._newOrderViewController.tabBarItem.title = @"New Order";
    
    self._existingOrdersViewController = [[ExistingOrdersViewController alloc] initWithNibName:@"ExistingOrdersViewController" bundle:nil];
    self._existingOrdersViewController.tabBarItem.title = @"Existing Orders";
    
    return @[self._existingOrdersViewController, self._newOrderViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
