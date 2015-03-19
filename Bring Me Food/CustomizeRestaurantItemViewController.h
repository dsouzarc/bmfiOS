//
//  CustomizeRestaurantItemViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeRestaurantItemViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantName:(NSString*)restaurantName itemName:(NSString*)itemName itemDescription:(NSString*)itemName itemCost:(NSString*)itemCost;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

@end
