//
//  ViewOrderDetailsViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/2/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewOrderDetailsViewController.h"
#import "RestaurantItemTableViewCell.h"
#import "RestaurantItem.h"

@interface ViewOrderDetailsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *orderStatus;
@property (strong, nonatomic) IBOutlet UILabel *estimatedDeliveryTime;
@property (strong, nonatomic) IBOutlet UILabel *myDeliveryTime;
@property (strong, nonatomic) IBOutlet UIButton *driverLocationOnMapButton;
@property (strong, nonatomic) IBOutlet UILabel *myPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *driverNamed;
@property (strong, nonatomic) IBOutlet UIButton *driverPhone;
@property (strong, nonatomic) IBOutlet UILabel *deliveryAddress;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UITableView *myItemsTableView;
@property (strong, nonatomic) IBOutlet UILabel *orderCost;
@property (strong, nonatomic) IBOutlet UITextView *additionalDetails;

- (IBAction)showDriverLocationOnMap:(id)sender;
- (IBAction)callDriver:(id)sender;

@property (nonatomic, strong) Order *order;

@end

@implementation ViewOrderDetailsViewController

static NSString *orderItemIdentifier = @"menuItemCell";

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
    
    [self.myItemsTableView registerNib:[UINib nibWithNibName:@"RestaurantItemTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderItemIdentifier];
    
    self.orderStatus.text = self.order.statusToString;
    self.myDeliveryTime.text = [self getNiceDate:self.order.timeToBeDeliveredAt];
    self.myPhoneNumber.text = self.order.ordererPhoneNumber;
    self.deliveryAddress.text = self.order.deliveryAddressString;
    self.restaurantName.text = self.order.restaurantName;
    self.orderCost.text = self.orderCost;
    self.additionalDetails.text = self.order.additionalDetails;
    
    //UNCLAIMED
    if(self.order.orderStatus == 0) {
        self.estimatedDeliveryTime.text = @"Estimated Delivery Time: N/A";
        
    }
    
}

- (IBAction)showDriverLocationOnMap:(id)sender {
}

- (IBAction)callDriver:(id)sender {
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderItemIdentifier];
    
    if(!cell) {
        cell = [[RestaurantItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderItemIdentifier];
    }
    
    RestaurantItem *item = (RestaurantItem*) [self.order.chosenItems objectAtIndex:indexPath.row];
    
    cell.costLabel.text = item.itemCost;
    cell.nameLabel.text = item.itemName;
    cell.descriptionTextView.text = item.customizedItemDescription;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.order.chosenItems.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString*) getNiceDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *time = [dateFormatter stringFromDate:date];
    
    //If it is today, just say
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    
    
    if(isToday) {
        return [NSString stringWithFormat:@"Today @: %@", time];
    }
    else {
        [dateFormatter setDateFormat:@"dd/MM"];
        
        return [NSString stringWithFormat:@"%@ on %@", time, [dateFormatter stringFromDate:date]];
    }
}

@end
