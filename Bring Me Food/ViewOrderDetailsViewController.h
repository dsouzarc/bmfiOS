//
//  ViewOrderDetailsViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/2/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewController.h"
#import "Order.h"

@interface ViewOrderDetailsViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order*)order;

@end
