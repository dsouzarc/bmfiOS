//
//  CustomizeRestaurantItemViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "CustomizeRestaurantItemViewController.h"

@interface CustomizeRestaurantItemViewController ()

- (IBAction)cancelAddingItem:(id)sender;
- (IBAction)addItemToOrder:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *itemDetailsTextView;
@property (strong, nonatomic) IBOutlet UITextView *customItemsDetailTextView;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *customItemDescription;
@property (strong, nonatomic) NSString *itemCost;

@end

@implementation CustomizeRestaurantItemViewController

- (void)viewDidLoad
{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.shadowOpacity = 0.8;
    self.mainView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [super viewDidLoad];
}

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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor blueColor]CGColor];
    textField.layer.borderWidth= 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddingItem:(id)sender {
    
}

- (IBAction)addItemToOrder:(id)sender {
}
@end
