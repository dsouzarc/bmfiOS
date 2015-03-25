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
- (IBAction)reloadItemsButton:(id)sender;

@property (strong, nonatomic) NSMutableArray *existingOrders;
@property (strong, nonatomic) IBOutlet UITableView *existingOrdersTableView;

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
                Order *order = [[Order alloc] initWithEverything:[result objectForKey:@"restaurantName"]
                                                 deliveryAddress:[result objectForKey:@"deliveryAddressString"]
                                                       orderedAt:[[result objectForKey:@"createdAt"]
                                                                  dateByAddingTimeInterval:-3600*4]
                                             toBeDeliveredAtTime:[result objectForKey:@"timeToBeDeliveredAt"]
                                           estimatedDeliveryTime:[result objectForKey:@"estimatedDeliveryTime"]
                                                      orderItems:[result objectForKey:@"chosenItems"]
                                                     orderStatus:[[result objectForKey:@"orderStatus"] longValue]];
                [self.existingOrders addObject:order];
                
                NSLog(@"ORDERS: %@", order.restaurantName);
            }
            
            [self.existingOrdersTableView reloadData];
            
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.existingOrders.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *classifier = @"Cell";
    
    UITableViewCell *cell = [self.existingOrdersTableView dequeueReusableCellWithIdentifier:classifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:classifier];
    }
    
    cell.textLabel.text = ((RestaurantItem*) self.existingOrders[indexPath.row]).restaurantName;
    
    return cell;
}

- (IBAction)createNewOrder:(id)sender {
    CreateOrderViewController *createOrder = [[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:[NSBundle mainBundle]];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:createOrder animated:YES completion:nil];
    
    //self.view.window.rootViewController = createOrder;
}

- (IBAction)reloadItemsButton:(id)sender {
    [self updateOrders];
}
@end
