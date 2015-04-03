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

- (instancetype) initWithEverything:(NSString*)restaurantName deliveryAddress:(NSString*)deliveryAddress orderedAt:(NSDate*)orderedAt toBeDeliveredAtTime:(NSDate*)toBeDeliveredAtTime estimatedDeliveryTime:(NSDate*)estimatedDeliveryTime orderItems:(NSArray*)orderItems orderStatus:(NSInteger)orderStatus additionalDetails:(NSString*)additionalDetails driverLocation:(PFGeoPoint*)driverLocation dropOffLocation:(PFGeoPoint*)dropOffLocation;

- (instancetype) initFromDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *toBeDeliveredAtAddress;

@property (nonatomic, strong) NSDate *orderedAt;
@property (nonatomic, strong) NSDate *toBeDeliveredAtTime;
@property (nonatomic, strong) NSDate *estimatedDeliveryTime;

@property (nonatomic, strong) NSArray *orderItems;

@property (nonatomic) NSInteger orderStatus;

@property (nonatomic) NSString *additionalDetails;

@property (nonatomic, strong) PFGeoPoint *driverLocation;
@property (nonatomic, strong) PFGeoPoint *dropOffLocation;

@end
