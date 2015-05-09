//
//  ChooseRestaurantViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/14/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChooseMenuItemsVIewController.h"

@class ChooseRestaurantViewController;

@protocol ChooseRestaurantNameDelegate <NSObject>

- (void) chooseRestaurantViewController:(ChooseRestaurantViewController*)controller didFinishChoosing:(NSString*)chosenRestaurant;

@end

@interface ChooseRestaurantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ChooseRestaurantNameDelegate> delegate;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurants:(NSArray*)restaurants;

@end