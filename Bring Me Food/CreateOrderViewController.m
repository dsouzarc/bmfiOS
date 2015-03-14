//
//  CreateOrderViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "ChooseRestaurantViewController.h"
#import <Parse/Parse.h>

@interface CreateOrderViewController ()

- (IBAction)chooseRestaurantButton:(id)sender;
@property (nonatomic, strong) ChooseRestaurantViewController *chooseRestaurant;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void) chooseRestaurantViewController:(ChooseRestaurantViewController *)controller didFinishChoosing:(NSString *)chosenRestaurant
{
    self.restaurantNameLabel.text = chosenRestaurant;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getGoogleAPIKey {
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"ApiConfigurations" ofType:@"plist"];
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:plist];
    
    return config[@"GoogleAPIKey"];
}

- (IBAction)chooseRestaurantButton:(id)sender {
    [PFCloud callFunctionInBackground:@"getRestaurants" withParameters:nil block:^(NSArray *response, NSError *error ) {
        if(!error) {
            self.chooseRestaurant = [[ChooseRestaurantViewController alloc] initWithNibName:@"ChooseRestaurantViewController" bundle:[NSBundle mainBundle] restaurants:response];
            self.chooseRestaurant.delegate = self;
            [self.chooseRestaurant showInView:self.view shouldAnimate:YES];
            
        }
        else {
            NSLog(@"ERROR\t%@", error.description);
        }
    }];
}
@end
