//
//  ViewOrderDetailsViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/2/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewOrderDetailsViewController.h"

@interface ViewOrderDetailsViewController ()

@property (nonatomic, strong) Order *order;

@end

@implementation ViewOrderDetailsViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.order = order;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
