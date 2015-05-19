//
//  Order.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *ordererName;
@property (nonatomic, strong) NSString *ordererPhoneNumber;

@property (nonatomic, strong) PFGeoPoint *deliveryAddress;
@property (nonatomic, strong) NSString *deliveryAddressString;
@property (nonatomic, strong) NSString *additionalDetails;

@property (nonatomic) NSInteger orderStatus;

@property (nonatomic, strong) NSDate *timeToBeDeliveredAt;
@property (nonatomic, strong) NSDate *estimatedDeliveryTime;
@property (nonatomic, strong) NSDate *orderedAt;
@property (nonatomic, strong) NSString *orderCost;

@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *driverPhoneNumber;
@property (nonatomic, strong) PFGeoPoint *driverLocation;

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) PFGeoPoint *restaurantLocation;

@property (nonatomic, strong) NSArray *chosenItems;

- (instancetype) init;

- (instancetype) initWithEverything:(NSString*)orderId
                        ordererName:(NSString*)ordererName
                       ordererPhone:(NSString*)ordererPhone
                    deliveryAddress:(PFObject*)deliveryAddress
              deliveryAddressString:(NSString*)deliveryAddressString
                        orderStatus:(NSInteger)orderStatus
                timeToBeDeliveredAt:(NSDate*)timeToBeDeliveredAt
              estimatedDeliveryTime:(NSDate*)estimatedDeliveryTime
                          orderedAt:(NSDate*)orderedAt
                          orderCost:(NSString*)orderCost
                         driverName:(NSString*)driverName
                        driverPhone:(NSString*)driverPhone
                     driverLocation:(PFGeoPoint*)driverLocation
                     restaurantName:(NSString*)restaurantName
                 restaurantLocation:(PFGeoPoint*)restaurantLocation
                        chosenItems:(NSArray*)chosenItems
                  additionalDetails:(NSString*)additionalDetails;

- (instancetype) initWithPFObject:(PFObject*)object;

- (UIColor*) getOrderStatusColor;
- (NSString*) statusToString;

@end
