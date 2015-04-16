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
#import "UICKeyChainStore.h"

@interface CreateOrderViewController ()

- (IBAction)cancelNewOrder:(id)sender;
- (IBAction)chooseRestaurantButton:(id)sender;
- (IBAction)chooseAddressButton:(id)sender;
- (IBAction)chooseItemsButton:(id)sender;
- (IBAction)submitOrderButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITableView *chosenItemsTableView;
@property (strong, nonatomic) IBOutlet UILabel *orderCostLabel;
@property (strong, nonatomic) IBOutlet UITextField *myNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *myPhoneTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *deliveryTimeDatePicker;
@property (strong, nonatomic) IBOutlet UITextView *additionalDetails;

@property (strong, nonatomic) PQFBouncingBalls *loadingBouncingBalls;
@property (strong, nonatomic) UICKeyChainStore *keyChain;

//Choose View Controllers
@property (nonatomic, strong) ChooseRestaurantViewController *chooseRestaurant;
@property (nonatomic, strong) ChooseAddressViewController *chooseAddress;
@property (nonatomic, strong) ChooseMenuItemsViewController *chooseMenuItems;
@property (nonatomic, strong) CustomizeRestaurantItemViewController *customizeMenuItemViewController;

//Data from Parse
@property (nonatomic, strong) NSArray *allRestaurants;
@property (nonatomic, strong) NSMutableArray *allMenuItems;

//User selected data
@property (nonatomic, strong) PFGeoPoint *chosenAddress;
@property (nonatomic, strong) NSString *chosenRestaurant;
@property (nonatomic, strong) NSMutableArray *chosenMenuItems;

@property (nonatomic, strong) NSIndexPath *selectedRow;
@property NSInteger chosenMenuItemToCustomizeIndex;

@end

@implementation CreateOrderViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.keyChain = [[UICKeyChainStore alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.loadingBouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingBouncingBalls.jumpAmount = 50;
    self.loadingBouncingBalls.separation = 40;
    self.loadingBouncingBalls.zoomAmount = 40;
    self.loadingBouncingBalls.loaderColor = [UIColor blueColor];
    self.chosenItemsTableView.allowsMultipleSelection = NO;
    
    [self.deliveryTimeDatePicker setDate:[NSDate date]];
    [self.deliveryTimeDatePicker setMinimumDate:[NSDate date]];
    
    [self.myNameTextField setText:self.keyChain[@"name"]];
    [self.myPhoneTextField setText:self.keyChain[@"phoneNumber"]];
    
    [self.additionalDetails setText:additionalOrderDetailsString];
    [self.additionalDetails setTextColor:[UIColor lightGrayColor]];
}

static NSString *additionalOrderDetailsString = @"Additional Details";

- (IBAction)submitOrderButton:(id)sender {
    if(self.chosenRestaurant == nil) {
        [self showAlert:@"Incomplete Information" alertMessage:@"Please choose a restaurant" buttonName:@"Ok"];
        return;
    }
     
     if(self.chosenAddress == nil) {
         [self showAlert:@"Incomplete Information" alertMessage:@"Please enter an address to bring the food to" buttonName:@"ok:"];
         return;
     }
     
     if(self.chosenMenuItems == nil || self.chosenMenuItems.count == 0) {
         [self showAlert:@"Incomplete Information" alertMessage:@"Please choose items to order" buttonName:@"Ok"];
         return;
     }
    
    if(!self.chosenRestaurant) {
        NSLog(@"No chosen");
    }
    if(!self.myNameTextField.text) {
        NSLog(@"Name problem");
    }
    
    
    //TODO: CONFIRMATION + CALCULATE ORDER COST WITH SHIPPING + DELETE
    
    NSDictionary *orderInformation = @{@"restaurantName": self.chosenRestaurant,
                                       @"ordererName": self.myNameTextField.text,
                                       @"ordererPhoneNumber": self.myPhoneTextField.text,
                                       @"deliveryAddress": self.chosenAddress,
                                       @"deliveryAddressString": self.addressLabel.text,
                                       @"chosenItems": [self chosenMenuItemsDictionaryArray],
                                       @"orderCost": self.orderCostLabel.text,
                                       @"additionalDetails": self.additionalDetails.text,
                                       @"timeToDeliverAt": [self.deliveryTimeDatePicker date]};
    
    [PFCloud callFunctionInBackground:@"placeOrder" withParameters:orderInformation block:^(NSString* result, NSError *error) {
        if(!error) {
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            NSLog(@"Error");
            [self showAlert:@"Error placing order" alertMessage:@"Sorry, something went wrong while placing your order" buttonName:@"Try again"];
        }
    }];
    
    NSLog(@"GUCCI");
    
}

- (void) customizedRestaurantItemViewController:(CustomizeRestaurantItemViewController *)customizeRestaurantItemViewController customizedMenuItem:(RestaurantItem *)customizedMenuItem
{
    if(!self.chosenMenuItemToCustomizeIndex) {
        [self.chosenMenuItems replaceObjectAtIndex:self.chosenMenuItemToCustomizeIndex withObject:customizedMenuItem];
        self.chosenMenuItemToCustomizeIndex = nil;
        
        [self.chosenItemsTableView reloadData];
    }
}

- (NSArray*) chosenMenuItemsDictionaryArray
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:self.chosenMenuItems.count];
    
    for(RestaurantItem *item in self.chosenMenuItems) {
        NSDictionary *characteristics = @{@"itemName": item.itemName, @"itemCost": item.itemCost, @"itemDescription": item.itemDescription, @"customDescription": item.customizedItemDescription};
        [items addObject:characteristics];
    }
    
    return items;
}

- (IBAction)chooseItemsButton:(id)sender {
    
    if(self.chosenRestaurant == nil) {
        [self showAlert:@"Choose Restaurant" alertMessage:@"Please choose a restaurant first" buttonName:@"Ok"];
        return;
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
            
            self.chooseMenuItems = [[ChooseMenuItemsViewController alloc] initWithNibName:@"ChooseMenuItemsViewController"
                                                                                   bundle:[NSBundle mainBundle]
                                                                      restaurantMenuItems:self.allMenuItems
                                                                          chosenMenuItems:self.chosenMenuItems
                                                                           restaurantName:self.chosenRestaurant];
            self.chooseMenuItems.delegate = self;
            [self setModalPresentationStyle:UIModalPresentationFormSheet];
            [self presentViewController:self.chooseMenuItems animated:YES completion:nil];
            [self.loadingBouncingBalls hide];
        }];
    }
    
    else {
        //[self.chooseMenuItems showInView:self.view shouldAnimate:YES];
        self.chooseMenuItems.delegate = self;
        [self setModalPresentationStyle:UIModalPresentationPopover];
        [self presentViewController:self.chooseMenuItems animated:YES completion:nil];
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
        self.chooseRestaurant = [[ChooseRestaurantViewController alloc] initWithNibName:@"ChooseRestaurantViewController"
                                                                                 bundle:[NSBundle mainBundle]
                                                                            restaurants:self.allRestaurants];
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
    [self updateOrderCostLabel];
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
    self.chooseAddress = [[ChooseAddressViewController alloc] initWithNibName:@"ChooseAddressViewController"
                                                                       bundle:[NSBundle mainBundle]];
    self.chooseAddress.delegate = self;
    [self setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:self.chooseAddress animated:YES completion:nil];
}

- (void) chooseAddressViewController:(ChooseAddressViewController *)viewController chosenAddress:(PFGeoPoint*)chosenAddress addressName:(NSString *)addressName
{
    self.chosenAddress = chosenAddress;
    self.addressLabel.numberOfLines = 1;
    self.addressLabel.text = addressName;
    self.addressLabel.adjustsFontSizeToFitWidth=YES;
    self.addressLabel.minimumScaleFactor=0.5;
}

- (void) chooseRestaurantViewController:(ChooseRestaurantViewController *)controller didFinishChoosing:(NSString *)chosenRestaurant
{
    //Delegate from "ChooseRestaurantViewController"
    self.chosenRestaurant = chosenRestaurant;
    self.restaurantNameLabel.text = chosenRestaurant;
}

- (IBAction)cancelNewOrder:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateOrderCostLabel];
}

- (void) updateOrderCostLabel
{
    //Update the total cost
    if(!self.chosenMenuItems || self.chosenMenuItems.count == 0) {
        self.orderCostLabel.text = @"No items chosen yet";
    }
    
    else {
        double estimatedCost = 0;
        
        for(RestaurantItem *item in self.chosenMenuItems) {
            NSString *tempCost = [item.itemCost stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
            @try {
                estimatedCost += [tempCost doubleValue];
            }
            @catch (NSException *exception) {
                NSLog(@"ERROR PARSING ITEM COST: %@", item.description);
            }
        }
        
        self.orderCostLabel.text = [NSString stringWithFormat:@"$%.2f", estimatedCost];
    }
}

- (void) nameTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    RestaurantItem *item = (RestaurantItem*) [self.chosenMenuItems objectAtIndex:tapRecognizer.view.tag];
    self.chosenMenuItemToCustomizeIndex = tapRecognizer.view.tag;
    
    self.customizeMenuItemViewController = [[CustomizeRestaurantItemViewController alloc] initWithNibName:@"CustomizeRestaurantItemViewController" bundle:[NSBundle mainBundle] restaurantName:self.chosenRestaurant menuItem:item];
    
    self.customizeMenuItemViewController.delegate = self;
    [self.customizeMenuItemViewController showInView:self.view shouldAnimate:YES];
}

/****************************/
//    TABLEVIEW DELEGATES
/****************************/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.chosenMenuItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateOrderCostLabel];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chosenMenuItems.count;
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
    
    cell.itemNameAndCost.text = [NSString stringWithFormat:@"%@    $%@", menuItem.itemName, menuItem.itemCost];
    cell.itemNameAndCost.numberOfLines = 1;
    cell.itemNameAndCost.adjustsFontSizeToFitWidth = YES;
    
    if(!menuItem.description || menuItem.description.length < 3 || [menuItem.description isEqualToString:@" "]) {
        cell.descriptionTextView.text = @"No description available";
    }
    else {
        cell.descriptionTextView.text = menuItem.customizedItemDescription;
    }
    
    if([self.selectedRow isEqual:indexPath]) {
        cell.descriptionTextView.hidden = NO;
    }
    else {
        cell.descriptionTextView.hidden = YES;
    }
    
    cell.descriptionTextView.tag = indexPath.row;
    cell.itemNameAndCost.tag = indexPath.row;
    
    //Two taps for name to prompt
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [cell.itemNameAndCost addGestureRecognizer:tapGesture];
    cell.itemNameAndCost.userInteractionEnabled = YES;
    
    //1 tap for everything else
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [cell.descriptionTextView addGestureRecognizer:tapGesture];
    cell.descriptionTextView.userInteractionEnabled = YES;
    
    return cell;
}

/****************************/
//    TEXTVIEW DELEGATES
/****************************/

- (void) textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.cornerRadius=8.0f;
    textView.layer.masksToBounds=YES;
    textView.layer.borderColor=[[UIColor blueColor]CGColor];
    textView.layer.borderWidth= 2.0f;
    
    if(self.additionalDetails.text.length == 0) {
        [self.additionalDetails setTextColor:[UIColor lightGrayColor]];
        [self.additionalDetails setText:additionalOrderDetailsString];
    }
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    //Add some glow effect
    textView.layer.cornerRadius=8.0f;
    textView.layer.masksToBounds=YES;
    textView.layer.borderColor=[[UIColor blueColor]CGColor];
    textView.layer.borderWidth= 2.0f;
    
    if(textView == self.additionalDetails) {
        if([textView.text isEqualToString:additionalOrderDetailsString]) {
            [textView setText:@""];
            [textView setTextColor:[UIColor blackColor]];
        }
    }
}


/****************************/
//    TEXTFIELD DELEGATES
/****************************/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Add some glow effect
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor blueColor]CGColor];
    textField.layer.borderWidth= 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
