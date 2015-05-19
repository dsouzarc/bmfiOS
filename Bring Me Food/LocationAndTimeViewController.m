//
//  LocationAndTimeViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LocationAndTimeViewController.h"

@interface LocationAndTimeViewController ()

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) UICKeyChainStore *keychain;

@end

@implementation LocationAndTimeViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.order = order;
    self.keychain = [[UICKeyChainStore alloc] init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
