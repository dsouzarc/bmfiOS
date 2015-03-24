//
//  RestaurantItem.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "RestaurantItem.h"

@implementation RestaurantItem

- (instancetype) initWithEverything:(NSString *)restaurantName itemName:(NSString *)itemName itemCost:(NSString *)itemCost itemDescription:(NSString *)itemDescription
{
    self = [super init];
    
    if(self) {
        self.restaurantName = restaurantName ? restaurantName : @"";
        self.itemName = itemName ? itemName : @"";
        self.itemCost = itemCost ? itemCost : @"";
        self.itemDescription = itemDescription ? itemDescription : @"";
    }
    
    return self;
}

- (NSString*) description
{
    NSMutableString *information = [[NSMutableString alloc] init];
    [information appendFormat:@"Restaurant: %@", self.restaurantName];
    [information appendFormat:@" Name %@", self.itemName];
    [information appendFormat:@" Description: %@", self.itemDescription];
    [information appendFormat:@" Cost: %@", self.itemCost];
    return information;
}

@end
