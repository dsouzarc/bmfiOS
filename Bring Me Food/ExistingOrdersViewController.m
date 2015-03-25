//
//  ExistingOrdersViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/28/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ExistingOrdersViewController.h"
#import "CreateOrderViewController.h"
#import "Order.h"

@interface ExistingOrdersViewController ()

- (IBAction)createNewOrder:(id)sender;

@property (strong, nonatomic) NSMutableArray *existingOrders;

@end

@implementation ExistingOrdersViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.existingOrders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateOrders];
}

- (void) updateOrders
{
    [PFCloud callFunctionInBackground:@"getUsersLiveOrders" withParameters:nil block:^(NSArray *results, NSError *error) {
       
        if(!error) {
            
            [self.existingOrders removeAllObjects];
            
            for(NSDictionary *result in results) {
                
            }
            
        }
        
        else {
            NSLog([error description]);
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateOrders];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.existingOrders.count;
}

- (IBAction)createNewOrder:(id)sender {
    CreateOrderViewController *createOrder = [[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:[NSBundle mainBundle]];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:createOrder animated:YES completion:nil];
    
    //self.view.window.rootViewController = createOrder;
}
@end
