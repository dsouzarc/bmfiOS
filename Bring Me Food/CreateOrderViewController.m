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
#import "CustomizeRestaurantItemViewController.h"
#import "ChooseMenuItemsViewController.h"
#import "RestaurantItemTableViewCell.h"
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
@property (nonatomic, strong) ChooseMenuItemsViewController *chooseMenuItems;
@property (nonatomic, strong) CustomizeRestaurantItemViewController *customizeMenuItemViewController;

//Data from Parse
@property (nonatomic, strong) NSArray *allRestaurants;
@property (nonatomic, strong) NSMutableArray *allMenuItems;

//User selected data
@property (nonatomic, strong) SPGooglePlacesAutocompletePlace *chosenAddress;
@property (nonatomic, strong) NSString *chosenRestaurant;
@property (nonatomic, strong) NSMutableArray *chosenMenuItems;

@property (nonatomic, strong) NSIndexPath *selectedRow;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingBouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingBouncingBalls.jumpAmount = 50;
    self.loadingBouncingBalls.separation = 40;
    self.loadingBouncingBalls.zoomAmount = 40;
    self.loadingBouncingBalls.loaderColor = [UIColor blueColor];
    
    self.chosenItemsTableView.allowsMultipleSelection = NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.chosenMenuItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chosenMenuItems.count;
}

- (IBAction)chooseItemsButton:(id)sender {
    
    if(self.chosenRestaurant == nil) {
        self.chosenRestaurant = @"Tortugas";
        //[self showAlert:@"Choose Restaurant" alertMessage:@"Please choose a restaurant first" buttonName:@"Ok"];
        //return;
    }
    
    self.chooseMenuItems = [[ChooseMenuItemsViewController alloc] initWithNibName:@"ChooseMenuItemsViewController"
                                                                           bundle:[NSBundle mainBundle]
                                                              restaurantMenuItems:self.allMenuItems
                                                                  chosenMenuItems:self.chosenMenuItems
                                                                   restaurantName:self.chosenRestaurant];
    
    if(self.allMenuItems == nil) {
        [self.loadingBouncingBalls show];
        
        [PFCloud callFunctionInBackground:@"getMenuItems" withParameters:@{@"restaurantName": self.chosenRestaurant} block:^(NSArray *results, NSError *error) {
            
            if(error) {
                [self showAlert:@"Uh Oh" alertMessage:@"Sorry, something went wrong while fetching the menu" buttonName:@"Try again"];
                return;
            }
            
            if(self.chosenMenuItems == nil) {
                self.chosenMenuItems = [[NSMutableArray alloc] init];
            }
            
            NSMutableArray *menuItems = [[NSMutableArray alloc] init];
            
            for(NSDictionary *menuItem in results) {
                RestaurantItem *item = [[RestaurantItem alloc] initWithEverything:[menuItem objectForKey:@"restaurantName"]
                                                                         itemName:[menuItem objectForKey:@"itemName"]
                                                                         itemCost:[menuItem objectForKey:@"itemCost"]
                                                                  itemDescription:[menuItem objectForKey:@"itemDescription"]];
                [menuItems addObject:item];
            }
            
            self.allMenuItems = [[NSMutableArray alloc] initWithArray:menuItems];
            
            self.chooseMenuItems = [[ChooseMenuItemsViewController alloc] initWithNibName:@"ChooseMenuItemsViewController" bundle:[NSBundle mainBundle] restaurantMenuItems:self.allMenuItems chosenMenuItems:self.chosenMenuItems restaurantName:self.chosenRestaurant];
            self.chooseMenuItems.delegate = self;

            [self.chooseMenuItems showInView:self.view shouldAnimate:YES];
            [self.loadingBouncingBalls hide];
        }];
    }
    
    else {
        [self.chooseMenuItems showInView:self.view shouldAnimate:YES];
        self.chooseMenuItems.delegate = self;
        //[self setModalPresentationStyle:UIModalPresentationPopover];
        //[self presentViewController:self.chooseMenuItems animated:YES completion:nil];
    }
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
                self.chooseRestaurant = [[ChooseRestaurantViewController alloc] initWithNibName:@"ChooseRestaurantViewController" bundle:[NSBundle mainBundle] restaurants:self.allRestaurants];
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
        
        //Show the chooser
        self.chooseRestaurant = [[ChooseRestaurantViewController alloc] initWithNibName:@"ChooseRestaurantViewController" bundle:[NSBundle mainBundle] restaurants:self.allRestaurants];
        self.chooseRestaurant.delegate = self;
        [self.chooseRestaurant showInView:self.view shouldAnimate:YES];
        
        [self.loadingBouncingBalls hide];
    }
}

- (void) chooseMenuItemsViewController:(ChooseMenuItemsViewController *)chooseMenuItemsViewController chosenItems:(NSArray *)chosenItems
{
    [self.chosenMenuItems removeAllObjects];
    [self.chosenMenuItems addObjectsFromArray:chosenItems];
    [self.chosenItemsTableView reloadData];
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

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the previously clicked view, and hide it
    RestaurantItemTableViewCell *cell = (RestaurantItemTableViewCell*) [tableView cellForRowAtIndexPath:self.selectedRow];
    cell.descriptionTextView.hidden = YES;
    
    //Update our global variable
    self.selectedRow = indexPath;
    
    //Get the most recently clicked view and show its contents
    cell = (RestaurantItemTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.descriptionTextView.hidden = NO;
    
    if([cell.descriptionTextView.text length] == 0) {
        [cell.descriptionTextView setText:@"No description available"];
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectedRow && [indexPath isEqual:self.selectedRow]) {
        return 108;
    }
    
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell"];
    
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"RestaurantItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"menuItemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell"];
    }
    
    RestaurantItem *menuItem = [self.chosenMenuItems objectAtIndex:indexPath.row];
    
    cell.nameLabel.numberOfLines = 0;
    cell.costLabel.numberOfLines = 0;
    
    cell.nameLabel.text = menuItem.itemName;
    cell.costLabel.text = menuItem.itemCost;
    
    if(!menuItem.description || menuItem.description.length < 3 || [menuItem.description isEqualToString:@" "]) {
        cell.descriptionTextView.text = @"No description available";
    }
    else {
        cell.descriptionTextView.text = menuItem.itemDescription;
    }
    
    if([self.selectedRow isEqual:indexPath]) {
        cell.descriptionTextView.hidden = NO;
    }
    else {
        cell.descriptionTextView.hidden = YES;
    }
    
    cell.descriptionTextView.tag = indexPath.row;
    cell.nameLabel.tag = indexPath.row;
    cell.costLabel.tag = indexPath.row;
    
    //Two taps for name to prompt
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [cell.nameLabel addGestureRecognizer:tapGesture];
    cell.nameLabel.userInteractionEnabled = YES;
    
    //1 tap for everything else
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [cell.descriptionTextView addGestureRecognizer:tapGesture];
    cell.descriptionTextView.userInteractionEnabled = YES;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [cell.costLabel addGestureRecognizer:tapGesture];
    cell.costLabel.userInteractionEnabled = YES;
    
    return cell;
}

- (void) nameTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    RestaurantItem *item = (RestaurantItem*) [self.chosenMenuItems objectAtIndex:tapRecognizer.view.tag];
    
    self.customizeMenuItemViewController = [[CustomizeRestaurantItemViewController alloc] initWithNibName:@"CustomizeRestaurantItemViewController" bundle:[NSBundle mainBundle] restaurantName:self.chosenRestaurant menuItem:item];
    
    self.customizeMenuItemViewController.delegate = self;
    [self.customizeMenuItemViewController showInView:self.view shouldAnimate:YES];
}


@end
