//
//  LocationAndTimeViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 5/19/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LocationAndTimeViewController.h"

@interface LocationAndTimeViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *deliveryTimePicker;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *deliveryTimeLabel;

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) UICKeyChainStore *keychain;

@property (strong, nonatomic) PFGeoPoint *dropOffPoint;
@property (strong, nonatomic) NSString *dropOffAddress;

@property (strong, nonatomic) ChooseAddressViewController *chooseAddressViewController;

@end

@implementation LocationAndTimeViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(Order *)order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.order = order;
    self.keychain = [[UICKeyChainStore alloc] init];
    
    if(self.keychain[@"dropOffLatitude"] && self.keychain[@"dropOffLongitude"]) {
        self.dropOffPoint = [PFGeoPoint geoPointWithLatitude:[self.keychain[@"dropOffLatitude"] floatValue]
                                                   longitude:[self.keychain[@"dropOffLongitude"] floatValue]];
    }
    self.dropOffAddress = self.keychain[@"dropOffString"];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deliveryTimePicker.minimumDate = [NSDate date];
    self.deliveryTimePicker.date = [NSDate date];
    
    self.addressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    if(self.dropOffAddress) {
        [self.addressButton setTitle:self.dropOffAddress forState:UIControlStateNormal];
    }
}

- (void) chooseAddressViewController:(ChooseAddressViewController *)viewController
                       chosenAddress:(PFGeoPoint *)chosenAddress
                         addressName:(NSString *)addressName
{
    self.dropOffPoint = chosenAddress;
    self.dropOffAddress = addressName;
    [self.addressButton setTitle:self.dropOffAddress forState:UIControlStateNormal];
    self.addressButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.saveButton setTitle:@"Save"];
}

- (IBAction)addressButton:(id)sender {
    self.chooseAddressViewController = [[ChooseAddressViewController alloc]
                                        initWithNibName:@"ChooseAddressViewController"
                                        bundle:[NSBundle mainBundle]];
    self.chooseAddressViewController.delegate = self;
    self.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:self.chooseAddressViewController animated:YES completion:nil];
    [self.saveButton setTitle:@"Save"];
}

- (IBAction)nextButton:(id)sender {
    self.order.deliveryAddress = self.dropOffPoint;
    self.order.deliveryAddressString = self.dropOffAddress;
}

- (IBAction)saveButton:(id)sender {
    self.keychain[@"dropOffLatitude"] = [NSString stringWithFormat:@"%f", self.dropOffPoint.latitude];
    self.keychain[@"dropOffLongitude"] = [NSString stringWithFormat:@"%f", self.dropOffPoint.longitude];
    self.keychain[@"dropOffString"] = self.dropOffAddress;
    [self.saveButton setTitle:@"Saved"];
}

- (IBAction)backButton:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deliveryTimePicker:(id)sender {
    NSDate *chosenTime = self.deliveryTimePicker.date;
    
    NSInteger seconds = [chosenTime timeIntervalSinceNow];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) {
        seconds -= days * 3600 * 24;
    }
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) {
        seconds -= hours * 3600;
    }
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) {
        seconds -= minutes * 60;
    }
    
    NSMutableString *text = [[NSMutableString alloc] init];
    [text appendString:@"Delivery Time: "];
    
    if(hours) {
        [text appendString:[NSString stringWithFormat:@"%d hours ", hours]];
        
        if(minutes) {
            [text appendString:[NSString stringWithFormat:@"and %d minutes ", minutes]];
        }
    }
    else {
        [text appendString:[NSString stringWithFormat:@"%d minutes ", minutes]];
    }
    [text appendString:@"from now"];
    
    self.deliveryTimeLabel.text = text;
    self.deliveryTimeLabel.adjustsFontSizeToFitWidth = YES;
}

@end
