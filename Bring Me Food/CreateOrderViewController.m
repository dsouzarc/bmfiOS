//
//  CreateOrderViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/12/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"

@interface CreateOrderViewController ()

- (IBAction)cancelOrder:(id)sender;


@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:[self getGoogleAPIKey]];
    
    query.input = @"23 Silvers Lane";
    query.types = SPPlaceTypeGeocode;
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if(!error) {
            NSLog(@"Places: %@", places);
        }
        else {
            NSLog(error.description);
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)getGoogleAPIKey {
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"ApiConfigurations" ofType:@"plist"];
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:plist];
    
    return config[@"GoogleAPIKey"];
}

@end
