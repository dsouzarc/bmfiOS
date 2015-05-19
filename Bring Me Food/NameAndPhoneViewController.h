//
//  NameAndPhoneViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

@interface NameAndPhoneViewController : UIViewController <UITextFieldDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray *)restaurantMenuItems chosenMenuItems:(NSMutableArray *)chosenItems restaurantName:(NSString *)restaurantName;

@end
