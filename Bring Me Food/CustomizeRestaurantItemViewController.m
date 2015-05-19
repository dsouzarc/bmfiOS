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
@property (strong, nonatomic) IBOutlet UILabel *currentCostLabel;
@property (strong, nonatomic) IBOutlet UIStepper *increaseCostStepper;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *customItemDescription;
@property (strong, nonatomic) NSString *itemCost;
@property double currentCostDouble;

@end

@implementation CustomizeRestaurantItemViewController

static NSString *customPlaceHolder = @"Type your customized order details here";

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantName:(NSString *)restaurantName menuItem:(RestaurantItem *)menuItem
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.restaurantName = restaurantName;
        self.itemName = menuItem.itemName;
        self.itemDescription = menuItem.itemDescription;
        self.customItemDescription = menuItem.customizedItemDescription;
        
        self.itemCost = menuItem.itemCost;
        self.currentCostDouble = [menuItem.itemCost doubleValue];
    }
    
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.shadowOpacity = 0.8;
    self.mainView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.mainView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    self.restaurantNameLabel.text = self.restaurantName;
    self.itemNameLabel.text = self.itemName;
    
    if(!self.itemDescription || [self.itemDescription length] <= 3) {
        self.itemDetailsTextView.text = @"No description available";
    }
    else {
        self.itemDetailsTextView.text = self.itemDescription;
    }
    
    self.customItemsDetailTextView.delegate = self;
    self.customItemsDetailTextView.layer.cornerRadius = 8;
    self.customItemsDetailTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if(!self.customItemDescription || self.customItemDescription.length == 0) {
        self.customItemsDetailTextView.text = customPlaceHolder;
        self.customItemsDetailTextView.textColor = [UIColor lightGrayColor];
    }
    else {
        self.customItemsDetailTextView.text = self.customItemDescription;
    }
    
    self.currentCostLabel.text = self.itemCost;
    self.increaseCostStepper.value = self.currentCostDouble;
    self.increaseCostStepper.minimumValue = self.currentCostDouble;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];


    [super viewDidLoad];
}

- (void) tapReceived:(UITapGestureRecognizer*)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    //Add some glow effect
    textView.layer.cornerRadius=8.0f;
    textView.layer.masksToBounds=YES;
    textView.layer.borderColor=[[UIColor blueColor]CGColor];
    textView.layer.borderWidth= 2.0f;
    
    if(textView == self.customItemsDetailTextView) {
        if([textView.text isEqualToString:customPlaceHolder]) {
            [textView setText:@""];
            [textView setTextColor:[UIColor blackColor]];
        }
        [textView becomeFirstResponder];
    }
}

- (IBAction)valueChanged:(UIStepper *)stepper
{
    self.currentCostDouble = [stepper value];
    [self.currentCostLabel setText:[NSString stringWithFormat:@"%.2f", self.currentCostDouble]];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    //Remove the flow effect
    textView.layer.borderColor=[[UIColor clearColor]CGColor];
    
    if(textView == self.customItemsDetailTextView) {
        if([textView.text isEqualToString:@""]) {
            [textView setText:customPlaceHolder];
            [textView setTextColor:[UIColor lightGrayColor]];
        }
        [textView resignFirstResponder];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddingItem:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addItemToOrder:(id)sender {
    
    NSString *description = [self.customItemsDetailTextView.text containsString:customPlaceHolder] ? @"" :
    self.customItemsDetailTextView.text;
    
    RestaurantItem *newItem = [[RestaurantItem alloc] initWithEverything:self.restaurantName
                                                                itemName:self.itemName
                                                                itemCost:[NSString stringWithFormat:@"%.2f", self.currentCostDouble]
                                                         itemDescription:self.itemDescription
                                                         customizedDescription:description];
    
    [self.delegate customizedRestaurantItemViewController:self customizedMenuItem:newItem];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
