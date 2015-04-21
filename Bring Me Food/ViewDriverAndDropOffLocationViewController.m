//
//  ViewDriverAndDropOffLocationViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewDriverAndDropOffLocationViewController.h"

@interface ViewDriverAndDropOffLocationViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Order *order;

@property (strong, nonatomic) PQFCirclesInTriangle *loadingAnimation;

@property (strong, nonatomic) PFGeoPoint *driverLocation;
@property (strong, nonatomic) PFGeoPoint *restaurantLocation;
@property (strong, nonatomic) PFGeoPoint *deliveryLocation;

- (IBAction)refreshMap:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation ViewDriverAndDropOffLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showPointsOnMap];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.order = order;
        
        self.driverLocation = order.driverLocation;
        self.restaurantLocation = order.restaurantLocation;
        self.deliveryLocation = order.deliveryAddress;
        
        self.loadingAnimation = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        self.loadingAnimation.loaderColor = [UIColor blueColor];
        self.loadingAnimation.numberOfCircles = 6;
    }
    return self;
}

- (void) showPointsOnMap
{
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self coordinateFromGeoPoint:self.restaurantLocation], 1600, 1600);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *restaurant = [[MKPointAnnotation alloc] init];
    restaurant.coordinate = [self coordinateFromGeoPoint:self.restaurantLocation];
    restaurant.title = self.order.restaurantName;
    
    MKPointAnnotation *deliveryAddress = [[MKPointAnnotation alloc] init];
    deliveryAddress.coordinate = [self coordinateFromGeoPoint:self.deliveryLocation];
    deliveryAddress.title = @"Delivery Location";
    deliveryAddress.subtitle = self.order.deliveryAddressString;
    
    MKPointAnnotation *driverLocation = [[MKPointAnnotation alloc] init];
    driverLocation.coordinate = [self coordinateFromGeoPoint:self.driverLocation];
    driverLocation.title = @"Driver Location";
    driverLocation.subtitle = self.order.driverName;
    
    NSArray *annotations = [[NSArray alloc] initWithObjects:restaurant, deliveryAddress, driverLocation, nil];
    
    [self.mapView addAnnotations:annotations];
    [self.mapView showAnnotations:annotations animated:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView selectAnnotation:driverLocation animated:YES];
}

- (CLLocationCoordinate2D) coordinateFromGeoPoint:(PFGeoPoint*)geoPoint
{
    return CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
}

- (IBAction)refreshMap:(id)sender {
    
    //Do nothing if the order has already been delivered
    if(self.order.orderStatus == 4) {
        return;
    }
    
    [self.loadingAnimation show];
    
    [PFCloud callFunctionInBackground:@"getDriverLocation" withParameters:@{@"orderID": self.order.orderId} block:^(NSDictionary *results, NSError *error) {
        
        [self.loadingAnimation hide];
        
        if(error) {
            UIAlertView *problem = [[UIAlertView alloc] initWithTitle:@"Problem" message:@"Sorry, something went wrong while trying to get the updated status of your order" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [problem show];
            NSLog(error.description);
        }
        
        else {
            self.driverLocation = results[@"driverLocation"];
            self.restaurantLocation = results[@"restaurantLocation"];
            self.deliveryLocation = results[@"deliveryLocation"];
            [self showPointsOnMap];
        }
    }];
}

- (IBAction)done:(id)sender {
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
