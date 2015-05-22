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
#import "ChooseMenuItemsViewController.h"
#import "CustomizeRestaurantItemViewController.h"
#import "ChooseMenuItemsViewController.h"
#import "Order.h"
#import "RestaurantItemTableViewCell.h"

#import <Parse/Parse.h>
#import "RestaurantItem.h"
#import "PQFBouncingBalls.h"
#import "UICKeyChainStore.h"

@interface CreateOrderViewController : UIViewController <ChooseAddressDelegate, UITableViewDataSource, UITableViewDelegate, CustomizeRestaurantItemDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order;

@end
