//
//  LogInViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/23/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LogInViewController.h"
#import "PQFCirclesInTriangle.h"
#import "ExistingOrdersViewController.h"
#import "LogInToExistingAccountViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "UICKeyChainStore.h"

@interface LogInViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *createAccountTitle;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;

@property (strong, nonatomic) PQFCirclesInTriangle *loadingCircles;
@property (strong, nonatomic) UICKeyChainStore *keyChain;

- (IBAction)signUpForAccount:(id)sender;

@property (strong, nonatomic) LogInToExistingAccountViewController *loginPopupVC;

@end

@implementation LogInViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.keyChain = [[UICKeyChainStore alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createAccountTitle.adjustsFontSizeToFitWidth = YES;
    self.phoneNumberTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.signInLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInLabelClicked)];
    [self.signInLabel addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
}


- (void)signInLabelClicked
{
    self.loginPopupVC = [[LogInToExistingAccountViewController alloc] initWithNibName:@"LogInToExistingAccountViewController" bundle:[NSBundle mainBundle]];
    
    [self.loginPopupVC showInView:self.view shouldAnimate:YES];
    
    NSLog(@"BACK");
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
    
    PFUser *newUser = [PFUser user];
    newUser.username = phoneNumber;
    newUser.password = password;
    newUser.email = email;
    newUser[@"name"] = name;
    newUser[@"phoneNumber"] = phoneNumber;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(!error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:newUser.objectId forKey:@"channels"];
                NSLog(@"USER ID: %@", newUser.objectId);
                
                [currentInstallation saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                    if(error) {
                        NSLog(@"Error saving");
                    }
                }];
            });
            
            self.keyChain[@"username"] = phoneNumber;
            self.keyChain[@"password"] = password;
            self.keyChain[@"phoneNumber"] = self.phoneNumberTextField.text;
            self.keyChain[@"name"] = name;
            self.keyChain[@"emailAddress"] = email;
            
            MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
            self.view.window.rootViewController = mainViewController;
            
            [self.loadingCircles hide];
        }
        else {
            [self.loadingCircles hide];
            UIAlertView *existing = [[UIAlertView alloc]
                                     initWithTitle:@"Problem signing up"
                                     message:@"It seems like you already have an account"
                                     delegate:nil cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [existing show];
        }
    }];
}

/****************************/
//    VALIDATION METHODS
/****************************/

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

/****************************/
//    TEXTFIELD & TOUCH DELEGATES
/****************************/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor whiteColor]CGColor];
    textField.layer.borderWidth= 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

@end
