//
//  CreateOrderViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseAddressViewController.h"
#import "ChooseRestaurantViewController.h"

@interface CreateOrderViewController : UIViewController <ChooseRestaurantNameDelegate, ChooseAddressDelegate>

@end
