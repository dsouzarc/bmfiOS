//
//  RestaurantItem.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantItem : NSObject

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemCost;
@property (nonatomic, strong) NSString *itemDescription;

- (instancetype) initWithEverything:(NSString*)restaurantName itemName:(NSString*)itemName itemCost:(NSString*)itemCost itemDescription:(NSString*)itemDescription;

- (NSString*) description;

@end
