//
//  ChooseRestaurantViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/14/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseRestaurantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurants:(NSArray*)restaurants;

@end