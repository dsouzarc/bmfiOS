//
//  NameAndPhoneViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "NameAndPhoneViewController.h"

@interface NameAndPhoneViewController ()

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButtonOriginal;

@property (strong, nonatomic) LocationAndTimeViewController *locationAndTimeVC;

- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)nextButton:(id)sender;

@end

@implementation NameAndPhoneViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.order = order;
    self.keychain = [[UICKeyChainStore alloc] init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.name setText:self.keychain[@"name"]];
    [self.phoneNumber setText:self.keychain[@"phoneNumber"]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor blueColor]CGColor];
    textField.layer.borderWidth= 2.0f;
    [self.saveButtonOriginal setTitle:@"Save"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void) animateText: (UIView*)textView up:(BOOL)up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)saveButton:(id)sender {
    self.keychain[@"name"] = self.name.text;
    self.keychain[@"phoneNumber"] = self.phoneNumber.text;
    [self.saveButtonOriginal setTitle: @"Saved"];
}

- (IBAction)cancelButton:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextButton:(id)sender {
    self.order.ordererName = self.name.text;
    self.order.ordererPhoneNumber = self.phoneNumber.text;
    
    self.locationAndTimeVC = [[LocationAndTimeViewController alloc] initWithNibName:@"LocationAndTimeViewController" bundle:[NSBundle mainBundle] order:self.order];
    
    self.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.locationAndTimeVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.view endEditing:YES];
}

@end
