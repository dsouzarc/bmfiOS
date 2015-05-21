//
//  LocationAndTimeViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateOrderViewController.h"
#import "Order.h"
#import <Parse/Parse.h>
#import "ChooseAddressViewController.h"
#import "UICKeyChainStore.h"

@interface LocationAndTimeViewController : UIViewController <ChooseAddressDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order*)order;

@end
