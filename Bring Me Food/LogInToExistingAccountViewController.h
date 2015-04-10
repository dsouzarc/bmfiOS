//
//  LogInToExistingAccountViewController.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/27/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface LogInToExistingAccountViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)exitButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *popupView;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

@end
