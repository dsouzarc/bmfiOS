//
//  ChooseMenuItemsViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizeRestaurantItemViewController.h"

@class ChooseMenuItemsViewController;

@protocol ChooseMenuItemsDelegate <NSObject>

- (void) chooseMenuItemsViewController:(ChooseMenuItemsViewController*)chooseMenuItemsViewController chosenItems:(NSArray*)chosenItems;

@end

@interface ChooseMenuItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CustomizeRestaurantItemDelegate>

@property (weak, nonatomic) id<ChooseMenuItemsDelegate> delegate;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray*)restaurantMenuItems chosenMenuItems:(NSMutableArray*)chosenItems restaurantName:(NSString*)restaurantName;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

@end
