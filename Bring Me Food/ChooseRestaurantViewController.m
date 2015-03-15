//
//  ChooseRestaurantViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/14/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ChooseRestaurantViewController.h"
#import <Parse/Parse.h>

@interface ChooseRestaurantViewController ()

@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseRestaurantViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurants:(NSArray *)restaurants
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.restaurants = [[NSArray alloc] initWithArray:restaurants];
    return self;
}


- (void)viewDidLoad
{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.shadowOpacity = 0.8;
    self.tableView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurants.count;
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *chosenRestaurant = [self.restaurants objectAtIndex:indexPath.row];
    
    //Tell CreateOrderViewController which Restaurant was chosen
    [self.delegate chooseRestaurantViewController:self didFinishChoosing:chosenRestaurant];
    
    [self removeAnimate];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.restaurants objectAtIndex:indexPath.row];
    
    return cell;
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

@end
