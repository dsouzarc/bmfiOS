//
//  Order.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *toBeDeliveredAtAddress;

@property (nonatomic, strong) NSDate *orderedAt;
@property (nonatomic, strong) NSDate *toBeDeliveredAtTime;
@property (nonatomic, strong) NSDate *estimatedDeliveryTime;

@property (nonatomic, strong) NSArray *orderItems;

@property (nonatomic) NSInteger orderStatus;



@end
