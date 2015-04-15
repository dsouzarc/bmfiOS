//
//  LogInToExistingAccountViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/27/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Parse/Parse.h>
#import "LogInToExistingAccountViewController.h"
#import "UICKeyChainStore.h"
#import "PQFBouncingBalls.h"
#import "ExistingOrdersViewController.h"

@interface LogInToExistingAccountViewController () <UITextFieldDelegate>

- (IBAction)loginButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (nonatomic, strong) PQFBouncingBalls *loadingAnimation;
@property (nonatomic, strong) UICKeyChainStore *keyChain;

@end

@implementation LogInToExistingAccountViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.keyChain = [[UICKeyChainStore alloc] init];
    }
    return self;
}

- (IBAction)loginButtonClicked:(id)sender {
    
    if(self.usernameTextField.text.length <= 5) {
        UIAlertView *problem = [[UIAlertView alloc]
                                initWithTitle:@"Invalid field"
                                message:@"Please enter a valid username"
                                delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles: nil];
        [problem show];
        return;
    }
    
    if(self.passwordTextField.text.length <= 5) {
        UIAlertView *problem = [[UIAlertView alloc]
                                initWithTitle:@"Invalid field"
                                message:@"Please enter a valid password"
                                delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles: nil];
        [problem show];
        return;
    }
    
    self.loadingAnimation = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingAnimation.label.text = @"Logging in...";
    self.loadingAnimation.label.textColor = [UIColor blueColor];
    self.loadingAnimation.jumpAmount = 50;
    self.loadingAnimation.separation = 40;
    self.loadingAnimation.zoomAmount = 40;
    self.loadingAnimation.loaderColor = [UIColor blueColor];
    [self.loadingAnimation show];
    
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            PFQuery *query = [PFUser query];
                                            [query whereKey:@"username" equalTo:self.usernameTextField.text];
                                            
                                            [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                                                if(!error) {
                                                    PFObject *first = (PFObject*)results[0];
                                                    
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                                                   ^(void) {
                                                        
                                                                       PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                                       [currentInstallation addUniqueObject:user.objectId forKey:@"channels"];
                                                                       NSLog(@"USER ID: %@", user.objectId);
                                                        
                                                                       [currentInstallation saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                                                                           if(error) {
                                                                                NSLog(@"Error saving");
                                                                            }
                                                                       }];
                                                                   });
                                                    
                                                    self.keyChain[@"username"] = first[@"username"];
                                                    self.keyChain[@"password"] = self.passwordTextField.text;
                                                    self.keyChain[@"phoneNumber"] = [first objectForKey:@"phoneNumber"];
                                                    self.keyChain[@"name"] = first[@"name"];
                                                    self.keyChain[@"emailAddress"] = first[@"email"];
                                                }
                                            }];
                                            
                                            ExistingOrdersViewController *existingOrders = [[ExistingOrdersViewController alloc] initWithNibName:@"ExistingOrdersViewController" bundle:nil];
                                            existingOrders.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                            
                                            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                            [appDelegate.window setRootViewController:existingOrders];
                                            [self closePopup:sender];
                                        }
                                        else {
                                            UIAlertView *problem = [[UIAlertView alloc]
                                                                    initWithTitle:@"Invalid Credentials"
                                                                    message:@"Username and Password Combo not found"
                                                                    delegate:nil
                                                                    cancelButtonTitle:@"Re-enter"
                                                                    otherButtonTitles: nil];
                                            [problem show];
                                            [self.loadingAnimation hide];
                                        }
                                    }];
    
    /*[PFCloud callFunctionInBackground:@"login"
                       withParameters:@{@"username": self.usernameTextField.text,
                                        @"password": self.passwordTextField.text}
                        block:^(NSString *result, NSError *error) {
                            
                            if(!error) {
                                if([result containsString:@"YES"]) {
                                    NSLog(@"Logged in!");
                                    
                                    MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
                                    
                                    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                    
                                    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                    [appDelegate.window setRootViewController:mainViewController];
                                    [self closePopup:sender];
                                }
                                else {
                                    UIAlertView *problem = [[UIAlertView alloc]
                                                            initWithTitle:@"Invalid Credentials"
                                                            message:@"Username and Password Combo not found"
                                                            delegate:nil
                                                            cancelButtonTitle:@"Re-enter"
                                                            otherButtonTitles: nil];
                                    [problem show];
                                    [self.loadingAnimation hide];
                                    return;
                                }
                            }
                            else {
                                NSLog(@"Error: %@", error);
                                UIAlertView *problem = [[UIAlertView alloc]
                                                        initWithTitle:@"Uh-oh"
                                                        message:@"Something went wrong while trying to log you in"
                                                        delegate:nil
                                                        cancelButtonTitle:@"Try again"
                                                        otherButtonTitles: nil];
                                [self.loadingAnimation hide];
                                [problem show];
                                return;
                            }
                        }
     ];*/
}

- (void)viewDidLoad
{
    //self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    [super viewDidLoad];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

/****************************/
//    ANIMATION METHODS
/****************************/

- (void) showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void) removeAnimate
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        
        if(shouldAnimate) {
            [self showAnimate];
        }
    });
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

- (IBAction)closePopup:(id)sender
{
    [self removeAnimate];
}

- (IBAction)exitButton:(id)sender {
    [self closePopup:sender];
}

/****************************/
//    TEXTFIELD DELEGATES
/****************************/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor blueColor]CGColor];
    textField.layer.borderWidth= 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
