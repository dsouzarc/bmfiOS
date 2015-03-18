//
//  ChooseMenuItemsViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMenuItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray*)restaurantMenuItems chosenMenuItems:(NSMutableArray*)chosenItems;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

@end
