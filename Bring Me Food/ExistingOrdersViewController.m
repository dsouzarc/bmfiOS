//
//  ExistingOrdersViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/28/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ExistingOrdersViewController.h"
#import "CreateOrderViewController.h"

@interface ExistingOrdersViewController ()

- (IBAction)createNewOrder:(id)sender;

@property (strong, nonatomic) NSArray *allOrders;

@end

@implementation ExistingOrdersViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.allOrders = [[NSArray alloc] init];
    }
    
    return self;
}

- (void) updateOrders
{
    [PFCloud callFunctionInBackground:@"getUsersLiveOrders" withParameters:nil block:^(NSArray *results, NSError *error) {
       
        if(!error) {
            
            
        }
        
        else {
            NSLog([error description]);
        }
        
    }];
}

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
    CreateOrderViewController *createOrder = [[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:[NSBundle mainBundle]];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:createOrder animated:YES completion:nil];
    
    //self.view.window.rootViewController = createOrder;
}
@end
