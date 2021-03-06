//
//  Order.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "Order.h"
#import "RestaurantItem.h"

@implementation Order

- (instancetype) init
{
    //Intentionally blank constructor
    self = [super init];
    return self;
}

- (instancetype) initWithEverything:(NSString *)orderId ordererName:(NSString *)ordererName ordererPhone:(NSString *)ordererPhone deliveryAddress:(PFObject *)deliveryAddress deliveryAddressString:(NSString *)deliveryAddressString orderStatus:(NSInteger)orderStatus timeToBeDeliveredAt:(NSDate *)timeToBeDeliveredAt estimatedDeliveryTime:(NSDate *)estimatedDeliveryTime orderedAt:(NSDate *)orderedAt orderCost:(NSString *)orderCost driverName:(NSString *)driverName driverPhone:(NSString *)driverPhone driverLocation:(PFGeoPoint *)driverLocation restaurantName:(NSString *)restaurantName restaurantLocation:(PFGeoPoint *)restaurantLocation chosenItems:(NSArray *)chosenItems additionalDetails:(NSString *)additionalDetails
{
    self = [super init];
    
    if(self) {
        self.orderId = orderId;
        self.ordererName = ordererName;
        self.ordererPhoneNumber = ordererPhone;
        self.deliveryAddress = deliveryAddress;
        self.deliveryAddressString = deliveryAddressString;
        self.orderStatus = orderStatus;
        self.timeToBeDeliveredAt = timeToBeDeliveredAt;
        self.estimatedDeliveryTime = estimatedDeliveryTime;
        self.orderedAt = orderedAt;
        self.orderCost = orderCost;
        self.driverName = driverName;
        self.driverPhoneNumber = driverPhone;
        self.driverLocation = driverLocation;
        self.restaurantName = restaurantName;
        self.restaurantLocation = restaurantLocation;
        self.chosenItems = chosenItems;
        self.additionalDetails = additionalDetails;
    }
    
    return self;
}

- (instancetype) initWithPFObject:(PFObject *)object
{
    NSArray *jsonChosenItems = object[@"chosenItems"];
    NSMutableArray *correctChosenItems = [[NSMutableArray alloc] init];
    
    for(NSDictionary *item in jsonChosenItems) {
        RestaurantItem *restaurantItem = [[RestaurantItem alloc] initWithEverything:object[@"restaurantName"] itemName:item[@"itemName"] itemCost:item[@"itemCost"] itemDescription:item[@"itemDescription"] customizedDescription:item[@"customDescription"]];
        [correctChosenItems addObject:restaurantItem];
    }
    
    self = [self initWithEverything:object.objectId
                        ordererName:object[@"ordererName"]
                       ordererPhone:object[@"ordererPhoneNumber"]
                    deliveryAddress:object[@"deliveryAddress"]
              deliveryAddressString:object[@"deliveryAddressString"]
                        orderStatus:[object[@"orderStatus"] intValue]
                timeToBeDeliveredAt:object[@"timeToBeDeliveredAt"]
              estimatedDeliveryTime:object[@"estimatedDeliveryTime"]
                          orderedAt:object.createdAt
                          orderCost:object[@"orderCost"]
                         driverName:object[@"driverName"]
                        driverPhone:object[@"driverPhoneNumber"]
                     driverLocation:object[@"driverLocation"]
                     restaurantName:object[@"restaurantName"]
                 restaurantLocation:object[@"restaurantLocation"]
                        chosenItems:correctChosenItems
                  additionalDetails:object[@"additionalDetails"]];
    
    return self;
}

- (NSString*) statusToString
{
    switch(self.orderStatus) {
        case 0:
            return @"Order is unclaimed";
        case 1:
            return @"Order has been claimed";
        case 2:
            return @"Order has been placed";
        case 3:
            return @"Order is currently en route";
        case 4:
            return @"Order has been delivered";
        default:
            return @"Order is unclaimed";
    }
    
    return @"Unclaimed";
}

- (UIColor*) getOrderStatusColor
{
    switch(self.orderStatus) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor orangeColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor blackColor];
        default:
            return [UIColor redColor];
    }
}

@end
