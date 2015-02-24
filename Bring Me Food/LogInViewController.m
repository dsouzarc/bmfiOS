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
    
    NSString *name = self.userNameTextField.text;
    NSString *phoneNumber = self.phoneNumberTextField.text;
    NSString *email = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField;
    NSString *confirmedPassword = self.confirmPasswordTextField.text;
    
    if(![self validName:name]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Field"
                              message:@"Must enter your full name"
                              delegate:self cancelButtonTitle:@"Fix it" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(![self validPhoneNumber:phoneNumber]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Field"
                              message:@"Must enter your valid phone number"
                              delegate:self cancelButtonTitle:@"Fix it" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(![self validEmail:email]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Field"
                              message:@"Must enter your valid email address"
                              delegate:self cancelButtonTitle:@"Fix it" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(![self validPassword:password confirmPassword:confirmedPassword]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Field"
                              message:@"Passwords do not match"
                              delegate:self cancelButtonTitle:@"Fix it" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (BOOL) validName:(NSString*) nameString {
    if(nameString.length < 5) {
        return NO;
    }
    
    if(![nameString containsString:@" "]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) validPhoneNumber:(NSString*) phoneNumber {
    return YES;
}

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc]
                                  initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString
                                                     options:0 range:NSMakeRange(0, [emailString length])];
    
    return regExMatches != 0;
}

- (BOOL) validPassword:(NSString*) password confirmPassword:(NSString*)confirmedPassword {
    return YES;
}

@end
