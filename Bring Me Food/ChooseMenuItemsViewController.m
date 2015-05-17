//
//  ChooseMenuItemsViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ChooseMenuItemsViewController.h"
#import "RestaurantItem.h"
#import <Parse/Parse.h>
#import "PQFBouncingBalls.h"
#import "RestaurantItemTableViewCell.h"

@interface ChooseMenuItemsViewController ()

- (IBAction)doneAddingNewItems:(id)sender;
- (IBAction)cancelAddingNewItems:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *menuItemsTableView;

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSArray *restaurantMenuItems;
@property (strong, nonatomic) NSMutableArray *chosenItems;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) PQFBouncingBalls *bouncingBalls;

@property (strong, nonatomic) CustomizeRestaurantItemViewController *customizeMenuItemViewController;

@property NSIndexPath *selectedRow;

@end

@implementation ChooseMenuItemsViewController

static NSString* cellIdentifier = @"Cell";

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray *)restaurantMenuItems chosenMenuItems:(NSMutableArray *)chosenMenuItems restaurantName:(NSString*)restaurantName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.restaurantMenuItems = [[NSArray alloc] initWithArray:restaurantMenuItems];
        self.searchResults = [[NSMutableArray alloc] initWithArray:restaurantMenuItems];
        self.chosenItems = [[NSMutableArray alloc] initWithArray:chosenMenuItems];
        self.restaurantName = restaurantName;
    }
    
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantName:(NSString *)restaurantName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.restaurantName = restaurantName;
    
    self.chosenItems = [[NSMutableArray alloc] init];
    self.restaurantMenuItems = [[NSArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    [self updateMenuItems];
    
    return self;
}

- (void) updateMenuItems
{
    [self.bouncingBalls show];
    
    NSLog(@"We here");
    
    [PFCloud callFunctionInBackground:@"getMenuItems" withParameters:@{@"restaurantName": self.restaurantName} block:^(NSArray *results, NSError *error) {
        
        if(error) {
            [[[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Sorry, something went wrong while fetching the menu" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil] show];
            return;
        }
        
        if(self.chosenItems == nil) {
            self.chosenItems = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        
        for(NSDictionary *menuItem in results) {
            RestaurantItem *item = [[RestaurantItem alloc] initWithEverything:[menuItem objectForKey:@"restaurantName"]
                                                                     itemName:[menuItem objectForKey:@"itemName"]
                                                                     itemCost:[menuItem objectForKey:@"itemCost"]
                                                              itemDescription:[menuItem objectForKey:@"itemDescription"]];
            [menuItems addObject:item];
        }
        
        self.restaurantMenuItems = [[NSMutableArray alloc] initWithArray:menuItems];
        self.searchResults = [[NSMutableArray alloc] initWithArray:menuItems];
        
        [self.menuItemsTableView reloadData];
        [self.bouncingBalls hide];
    }];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResults removeAllObjects];
    [self.searchResults addObjectsFromArray:self.restaurantMenuItems];
    [self.menuItemsTableView reloadData];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //Clear the search
    [self.searchResults removeAllObjects];
    
    //Add items with matching names or descriptions
    for(RestaurantItem *item in self.restaurantMenuItems) {
        if([item.itemName containsString:searchText] || [item.itemDescription containsString:searchText]) {
            [self.searchResults addObject:item];
        }
    }
    
    //If there is no text or cancel button was pressed
    if(searchText.length == 0) {
        self.selectedRow = nil;
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:self.restaurantMenuItems];
    }
    
    [self.menuItemsTableView reloadData];
}

- (void)viewDidLoad
{
    [self.menuItemsTableView registerClass:[RestaurantItemTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [super viewDidLoad];
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
    
    RestaurantItem *menuItem = [self.searchResults objectAtIndex:indexPath.row];
    
    cell.itemNameAndCost.text = [NSString stringWithFormat:@"%@    %@", menuItem.itemName, menuItem.itemCost];
    cell.itemNameAndCost.numberOfLines = 1;
    cell.itemNameAndCost.adjustsFontSizeToFitWidth = YES;
    
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

- (void) customizedRestaurantItemViewController:(CustomizeRestaurantItemViewController *)customizeRestaurantItemViewController customizedMenuItem:(RestaurantItem *)customizedMenuItem
{
    if(customizedMenuItem) {
        [self.chosenItems addObject:customizedMenuItem];
    }
}

- (void) nameTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    RestaurantItem *item = (RestaurantItem*) [self.searchResults objectAtIndex:tapRecognizer.view.tag];
    
    self.customizeMenuItemViewController = [[CustomizeRestaurantItemViewController alloc] initWithNibName:@"CustomizeRestaurantItemViewController" bundle:[NSBundle mainBundle] restaurantName:self.restaurantName menuItem:item];
    
    self.customizeMenuItemViewController.delegate = self;
    
    //[self.customizeMenuItemViewController showInView:self.view shouldAnimate:YES];
    self.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:self.customizeMenuItemViewController animated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (IBAction)doneAddingNewItems:(id)sender {
    [self.delegate chooseMenuItemsViewController:self chosenItems:self.chosenItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddingNewItems:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
