//
//  CustomizeRestaurantItemViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

@class CustomizeRestaurantItemViewController;

@protocol CustomizeRestaurantItemDelegate <NSObject>

- (void) customizedRestaurantItemViewController:(CustomizeRestaurantItemViewController*)customizeRestaurantItemViewController customizedMenuItem:(RestaurantItem*)customizedMenuItem;

@end

@interface CustomizeRestaurantItemViewController : UIViewController <UITextViewDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantName:(NSString*)restaurantName menuItem:(RestaurantItem*)menuItem;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;
- (IBAction)valueChanged:(UIStepper *)stepper;

@property (nonatomic, weak) id<CustomizeRestaurantItemDelegate> delegate;

@end
