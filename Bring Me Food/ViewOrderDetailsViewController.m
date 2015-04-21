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

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allUILabels;

@property (nonatomic, strong) Order *order;

- (IBAction)callDriver:(id)sender;
- (IBAction)showDriverLocationOnMap:(id)sender;
- (IBAction)goBack:(id)sender;

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
    
    self.orderStatus.text = [NSString stringWithFormat:@"Status: %@", self.order.statusToString];
    self.orderStatus.textColor = self.order.
    
    self.myDeliveryTime.text = [NSString stringWithFormat:@"Time To Be Delivered At: %@", [self getNiceDate:self.order.timeToBeDeliveredAt]];
    self.myDeliveryTime.adjustsFontSizeToFitWidth = YES;
    self.myPhoneNumber.text = [NSString stringWithFormat:@"My Phone #: %@", self.order.ordererPhoneNumber];
    self.deliveryAddress.text = [NSString stringWithFormat:@"Delivery Address: %@", self.order.deliveryAddressString];
    self.restaurantName.text = [NSString stringWithFormat:@"Restaurant Name: %@", self.order.restaurantName];
    self.orderCost.text = [NSString stringWithFormat:@"Order Cost: %@", self.order.orderCost];
    self.additionalDetails.text = [NSString stringWithFormat:@"Additional Details: %@", self.order.additionalDetails];
    
    //UNCLAIMED
    if(self.order.orderStatus == 0) {
        self.estimatedDeliveryTime.text = @"Estimated Delivery Time: N/A";
        self.driverNamed.text = @"Driver Name: N/A";
        self.driverPhone.enabled = NO;
        self.driverLocationOnMapButton.enabled = NO;
    }
    else {
        
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderItemIdentifier];
    
    if(!cell) {
        cell = [[RestaurantItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderItemIdentifier];
    }
    
    RestaurantItem *item = (RestaurantItem*) [self.order.chosenItems objectAtIndex:indexPath.row];
    cell.itemNameAndCost.text = [NSString stringWithFormat:@"%@    $%@", item.itemName, item.itemCost];
    cell.itemNameAndCost.numberOfLines = 1;
    cell.itemNameAndCost.adjustsFontSizeToFitWidth = YES;
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
        [dateFormatter setDateFormat:@"MM/dd"];
        
        return [NSString stringWithFormat:@"%@ on %@", time, [dateFormatter stringFromDate:date]];
    }
}

- (IBAction)callDriver:(id)sender {
}

- (IBAction)showDriverLocationOnMap:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
