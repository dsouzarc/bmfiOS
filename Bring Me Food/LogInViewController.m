//
//  LogInViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/23/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)signUpForAccount:(id)sender;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUpForAccount:(id)sender {

    
}
@end
