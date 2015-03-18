//
//  CreateOrderViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "ChooseAddressViewController.h"
#import "ChooseRestaurantViewController.h"
#import <Parse/Parse.h>
#import "RestaurantItem.h"
#import "PQFBouncingBalls.h"

@interface CreateOrderViewController ()
- (IBAction)cancelNewOrder:(id)sender;

- (IBAction)chooseRestaurantButton:(id)sender;
- (IBAction)chooseAddressButton:(id)sender;
- (IBAction)chooseItemsButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITableView *chosenItemsTableView;

@property (strong, nonatomic) PQFBouncingBalls *loadingBouncingBalls;

//Choose View Controllers
@property (nonatomic, strong) ChooseRestaurantViewController *chooseRestaurant;
@property (nonatomic, strong) ChooseAddressViewController *chooseAddress;

//Data from Parse
@property (nonatomic, strong) NSArray *allRestaurants;
@property (nonatomic, strong) NSArray *allMenuItems;

//User selected data
@property (nonatomic, strong) SPGooglePlacesAutocompletePlace *chosenAddress;
@property (nonatomic, strong) NSString *chosenRestaurant;
@property (nonatomic, strong) NSArray *chosenMenuItems;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingBouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingBouncingBalls.jumpAmount = 50;
    self.loadingBouncingBalls.separation = 40;
    self.loadingBouncingBalls.zoomAmount = 40;
    self.loadingBouncingBalls.loaderColor = [UIColor blueColor];

}

- (IBAction)chooseItemsButton:(id)sender {
    
    if(self.chosenRestaurant == nil) {
        [self showAlert:@"Choose Restaurant" alertMessage:@"Please choose a restaurant first" buttonName:@"Ok"];
        return;
    }
    
    if(self.allMenuItems == nil) {
        [self.loadingBouncingBalls show];
        
        [PFCloud callFunctionInBackground:@"getMenuItems" withParameters:@{@"restaurantName": self.chosenRestaurant} block:^(NSArray *results, NSError *error) {
            
            if(error) {
                [self showAlert:@"Uh Oh" alertMessage:@"Sorry, something went wrong while fetching the menu" buttonName:@"Try again"];
                return;
            }
            
            for(NSDictionary *menuItem in results) {
                RestaurantItem *item = [[RestaurantItem alloc] init];
                item.restaurantName = [menuItem objectForKey:@"restaurantOwner"];
                item.itemName = [menuItem objectForKey:@"itemName"];
                item.pr
            }
        }];
    }
    
}

- (IBAction)chooseRestaurantButton:(id)sender {
    
    //If we do not already have a list of restaurants from Parse
    if(self.allRestaurants == nil) {
        
        [self.loadingBouncingBalls show];
        
        //Get
        [PFCloud callFunctionInBackground:@"getRestaurants" withParameters:nil block:^(NSArray *response, NSError *error) {
            if(!error) {
                
                NSMutableArray *restaurantNames = [[NSMutableArray alloc] init];
                
                for(NSDictionary *json in response) {
                    [restaurantNames addObject:[json objectForKey:@"restaurantName"]];
                }
                
                //Cache it
                self.allRestaurants = [[NSArray alloc] initWithArray:restaurantNames];
                
                //Show the chooser
                self.chooseRestaurant = [[ChooseRestaurantViewController alloc]
                                         initWithNibName:@"ChooseRestaurantViewController"
                                         bundle:[NSBundle mainBundle]
                                         restaurants:self.allRestaurants];
                self.chooseRestaurant.delegate = self;
                [self.chooseRestaurant showInView:self.view shouldAnimate:YES];
                
                [self.loadingBouncingBalls hide];
            }
            else {
                NSLog(@"ERROR\t%@", error.description);
            }
        }];
    }
    
    //If we already have a list of restaurants
    else {
        //Show them
        self.chooseRestaurant = [[ChooseRestaurantViewController alloc]
                                 initWithNibName:@"ChooseRestaurantViewController"
                                 bundle:[NSBundle mainBundle]
                                 restaurants:self.allRestaurants];
        self.chooseRestaurant.delegate = self;
        [self.chooseRestaurant showInView:self.view shouldAnimate:YES];
    }
}

- (void) showAlert:(NSString*)alertTitle alertMessage:(NSString*)alertMessage buttonName:(NSString*)buttonName {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:buttonName
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)chooseAddressButton:(id)sender {
    self.chooseAddress = [[ChooseAddressViewController alloc] initWithNibName:@"ChooseAddressViewController" bundle:[NSBundle mainBundle]];
    self.chooseAddress.delegate = self;
    [self setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:self.chooseAddress animated:YES completion:nil];
}

- (void) chooseAddressViewController:(ChooseAddressViewController *)viewController chosenAddress:(SPGooglePlacesAutocompletePlace *)chosenAddress
{
    self.chosenAddress = chosenAddress;
    self.addressLabel.text = chosenAddress.name;
}

- (void) chooseRestaurantViewController:(ChooseRestaurantViewController *)controller didFinishChoosing:(NSString *)chosenRestaurant
{
    //Delegate from "ChooseRestaurantViewController"
    self.chosenRestaurant = chosenRestaurant;
    self.restaurantNameLabel.text = chosenRestaurant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelNewOrder:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
