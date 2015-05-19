//
//  LocationAndTimeViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "UICKeyChainStore.h"

@interface LocationAndTimeViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order*)order;

@end
