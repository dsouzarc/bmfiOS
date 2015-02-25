//
//  LogInViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/23/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LogInViewController.h"
#import "PQFCirclesInTriangle.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (strong, nonatomic) PQFCirclesInTriangle *loadingCircles;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

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
    NSString *password = self.passwordTextField.text;
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
    
    self.loadingCircles = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    self.loadingCircles.label.text = @"Creating account...";
    self.loadingCircles.borderWidth = 5.0;
    self.loadingCircles.maxDiam = 200.0;
    [self.loadingCircles show];
    
    
    PFObject *newUser = [PFObject objectWithClassName:@"User"];
    newUser[@"phoneNumber"] = phoneNumber;
    newUser[@"emailAddress"] = email;
    newUser[@"encryptedPassword"] = password;
    newUser[@"name"] = name;
    
    [newUser saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            NSLog(@"Success!");
            
            //[self.loadingCircles hide];
        }
        
    }];
    
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
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(phoneNumber.length < 10) {
        return NO;
    }
    
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
    
    if(![password isEqualToString:confirmedPassword]) {
        return NO;
    }
    
    if(password.length < 5) {
        return NO;
    }
    
    return YES;
}

@end
