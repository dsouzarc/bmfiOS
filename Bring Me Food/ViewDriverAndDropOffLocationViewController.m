//
//  ViewDriverAndDropOffLocationViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 4/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewDriverAndDropOffLocationViewController.h"
#import <MapKit/MapKit.h>

@interface ViewDriverAndDropOffLocationViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Order *order;

@end

@implementation ViewDriverAndDropOffLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapPoint *point = MKMapPointForCoordinate([[CLLocation alloc] initWithLatitude:self.order. longitude:<#(CLLocationDegrees)#>);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.order = order;
    }
    
    return self;
}

@end
