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
#import "PQFBouncingBalls.h"

@interface CreateOrderViewController ()

- (IBAction)chooseRestaurantButton:(id)sender;
- (IBAction)chooseAddressButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

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
    
    /*SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:[self getGoogleAPIKey]];
    
    query.input = @"23 Silvers Lane";
    query.types = SPPlaceTypeGeocode;
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if(!error) {
            NSLog(@"Places: %@", places);
        }
        else {
            NSLog(error.description);
        }
    }];*/
    
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


- (IBAction)chooseRestaurantButton:(id)sender {
    
    //If we do not already have a list of restaurants from Parse
    if(self.allRestaurants == nil) {
        
        [self.loadingBouncingBalls show];
        
        //Get
        [PFCloud callFunctionInBackground:@"getRestaurants" withParameters:nil block:^(NSArray *response, NSError *error) {
            if(!error) {
                
                //Cache it
                self.allRestaurants = [[NSArray alloc] initWithArray:response];
                
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

- (IBAction)chooseAddressButton:(id)sender {
    self.chooseAddress = [[ChooseAddressViewController alloc] initWithNibName:@"ChooseAddressViewController" bundle:[NSBundle mainBundle]];
    self.chooseAddress.delegate = self;
    [self setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:self.chooseAddress animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
