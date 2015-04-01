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
#import "OrdersTableViewCell.h"
#import "PQFBouncingBalls.h"

@interface ExistingOrdersViewController ()

- (IBAction)createNewOrder:(id)sender;
- (IBAction)reloadItemsButton:(id)sender;

@property (strong, nonatomic) NSMutableArray *existingOrders;
@property (strong, nonatomic) IBOutlet UITableView *existingOrdersTableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PQFBouncingBalls *bouncingBalls;
@property (strong, nonatomic) UILabel *noExistingOrders;

@end

@implementation ExistingOrdersViewController

static NSString *orderCellIdentifier = @"OrdersTableViewCell";

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.existingOrders = [[NSMutableArray alloc] init];
        self.bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        self.bouncingBalls.loaderColor = [UIColor blueColor];
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateOrders];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateOrders) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:(254/255.0) green:(153/255.0) blue:(0/255.0) alpha:1];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching your current orders"];
    
    UITableViewController *viewController = [[UITableViewController alloc] init];
    viewController.tableView = self.existingOrdersTableView;
    viewController.refreshControl = self.refreshControl;
}

- (void) updateOrders
{
    if(!self.refreshControl.refreshing) {
        [self.bouncingBalls show];
    }
    
    [PFCloud callFunctionInBackground:@"getUsersLiveOrders" withParameters:nil block:^(NSArray *results, NSError *error) {
        if(!error) {
            [self.existingOrders removeAllObjects];
            
            for(NSDictionary *result in results) {
                
                Order *order = [[Order alloc] initWithEverything:[result objectForKey:@"restaurantName"]
                                                 deliveryAddress:[result objectForKey:@"deliveryAddressString"]
                                                       orderedAt:[[result objectForKey:@"createdAt"]
                                                                  dateByAddingTimeInterval:-3600*4]
                                             toBeDeliveredAtTime:[result objectForKey:@"timeToDeliverAt"]
                                           estimatedDeliveryTime:[result objectForKey:@"estimatedDeliveryTime"]
                                                      orderItems:[result objectForKey:@"chosenItems"]
                                                     orderStatus:[[result objectForKey:@"orderStatus"] longValue]];
                [self.existingOrders addObject:order];
            }
            [self.existingOrdersTableView reloadData];
        }
        
        else {
            NSLog([error description]);
        }
        
        [self.bouncingBalls hide];
        
        if(self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.existingOrdersTableView registerNib:[UINib nibWithNibName:@"OrdersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderCellIdentifier];
    [self updateOrders];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.existingOrders.count > 0) {
        self.noExistingOrders.text = @"";
        self.noExistingOrders = nil;
        self.existingOrdersTableView.backgroundView = nil;
        self.existingOrdersTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    
    else {
        self.noExistingOrders = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        self.noExistingOrders.text = @"No prior orders";
        self.noExistingOrders.textColor = [UIColor blackColor];
        self.noExistingOrders.textAlignment = NSTextAlignmentCenter;
        self.existingOrdersTableView.backgroundView = self.noExistingOrders;
        self.existingOrdersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.existingOrders.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersTableViewCell *cell = [self.existingOrdersTableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
    
    if(!cell) {
        cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
    }
    
    Order *order = (Order*) self.existingOrders[indexPath.row];
    
    cell.restaurantNameLabel.text = order.restaurantName;
    
    NSString *orderStatus = @"Order Status";
    
    switch(order.orderStatus) {
        case 0:
            orderStatus = @"Unclaimed";
            cell.statusLabel.textColor = [UIColor redColor];
            break;
        case 1:
            orderStatus = @"Claimed";
            cell.statusLabel.textColor = [UIColor greenColor];
            break;
        case 2:
            orderStatus = @"En route";
            cell.statusLabel.textColor = [UIColor greenColor];
            break;
        case 3:
            orderStatus = @"Delivered";
            cell.statusLabel.textColor = [UIColor blackColor];
            break;
    }
    cell.statusLabel.text = orderStatus;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];

    cell.orderedOnDateLabel.text = [dateFormatter stringFromDate:order.orderedAt];
    
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
