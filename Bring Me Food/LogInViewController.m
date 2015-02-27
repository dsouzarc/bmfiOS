//
//  LogInViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/23/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LogInViewController.h"
#import "PQFCirclesInTriangle.h"
#import "LogInToExistingAccountViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;

@property (strong, nonatomic) PQFCirclesInTriangle *loadingCircles;

- (IBAction)signUpForAccount:(id)sender;

@property (strong, nonatomic) LogInToExistingAccountViewController *loginPopupVC;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumberTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    self.signInLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInLabelClicked)];
    [self.signInLabel addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signInLabelClicked
{
    self.loginPopupVC = [[LogInToExistingAccountViewController alloc] initWithNibName:@"LogInToExistingAccountViewController" bundle:[NSBundle mainBundle]];
    [self.loginPopupVC showInView:self.view shouldAnimate:YES];
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
    
    
    PFObject *newUser = [PFObject objectWithClassName:@"BMFUser"];
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
                                  initWithPattern:regExPattern
                                  options:NSRegularExpressionCaseInsensitive error:nil];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor whiteColor]CGColor];
    textField.layer.borderWidth= 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

@end
