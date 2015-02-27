//
//  LogInToExistingAccountViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 2/27/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LogInToExistingAccountViewController.h"
#import "PQFBouncingBalls.h"

@interface LogInToExistingAccountViewController ()

- (IBAction)loginButtonClicked:(id)sender;

@property (nonatomic, strong) PQFBouncingBalls *loadingAnimation;

@end

@implementation LogInToExistingAccountViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (IBAction)loginButtonClicked:(id)sender {
    
    self.loadingAnimation = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingAnimation.label.text = @"Logging in...";
    self.loadingAnimation.label.textColor = [UIColor blueColor];
    self.loadingAnimation.jumpAmount = 50;
    self.loadingAnimation.separation = 40;
    self.loadingAnimation.zoomAmount = 40;
    self.loadingAnimation.loaderColor = [UIColor blueColor];
    [self.loadingAnimation show];
    
    
}

- (void)viewDidLoad
{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
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

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        
        if(shouldAnimate) {
            [self showAnimate];
        }
    });
}

- (IBAction)closePopup:(id)sender
{
    [self removeAnimate];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
