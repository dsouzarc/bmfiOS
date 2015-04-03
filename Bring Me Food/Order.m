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

- (instancetype) initWithEverything:(NSString *)restaurantName deliveryAddress:(NSString *)deliveryAddress orderedAt:(NSDate *)orderedAt toBeDeliveredAtTime:(NSDate *)toBeDeliveredAtTime estimatedDeliveryTime:(NSDate *)estimatedDeliveryTime orderItems:(NSArray *)orderItems orderStatus:(NSInteger)orderStatus additionalDetails:(NSString *)additionalDetails
{
    self = [self init];
    
    if(self) {
        self.restaurantName = restaurantName;
        self.toBeDeliveredAtAddress = deliveryAddress;
        self.orderedAt = orderedAt;
        self.toBeDeliveredAtTime = toBeDeliveredAtTime;
        self.estimatedDeliveryTime = estimatedDeliveryTime;
        self.orderItems = orderItems;
        self.orderStatus = orderStatus;
        self.additionalDetails = additionalDetails;
    }
    
    return self;
}

- (instancetype) initFromDictionary:(NSDictionary *)dictionary
{
    self = [self initWithEverything:@"restaurantName" deliveryAddress:@"deliveryAddressString" orderedAt:@"createdAt" toBeDeliveredAtTime:@"timeToBeDeliveredAt" estimatedDeliveryTime:@"estimatedDeliveryTime" orderItems:@"chosenItems" orderStatus:@"orderStatus" additionalDetails:@"additionalDetails"];
    
    return self;
}

@end
