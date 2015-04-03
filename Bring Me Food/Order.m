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

- (instancetype) initWithEverything:(NSString *)orderId ordererName:(NSString *)ordererName ordererPhone:(NSString *)ordererPhone deliveryAddress:(PFObject *)deliveryAddress deliveryAddressString:(NSString *)deliveryAddressString orderStatus:(NSInteger)orderStatus timeToBeDeliveredAt:(NSDate *)timeToBeDeliveredAt estimatedDeliveryTime:(NSDate *)estimatedDeliveryTime orderedAt:(NSDate *)orderedAt orderCost:(NSString *)orderCost driverName:(NSString *)driverName driverPhone:(NSString *)driverPhone driverLocation:(PFGeoPoint *)driverLocation restaurantName:(NSString *)restaurantName restaurantLocation:(PFGeoPoint *)restaurantLocation chosenItems:(NSArray *)chosenItems
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
                        chosenItems:correctChosenItems];
    
    return self;
}

@end
