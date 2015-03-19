//
//  ChooseMenuItemsViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ChooseMenuItemsViewController.h"
#import "RestaurantItem.h"
#import "RestaurantItemTableViewCell.h"

@interface ChooseMenuItemsViewController ()

- (IBAction)doneAddingNewItems:(id)sender;
- (IBAction)cancelAddingNewItems:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *menuItemsTableView;

@property (strong, nonatomic) NSArray *restaurantMenuItems;
@property (strong, nonatomic) NSMutableArray *chosenItems;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property NSIndexPath *selectedRow;

@end

@implementation ChooseMenuItemsViewController

static NSString* cellIdentifier = @"Cell";

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray *)restaurantMenuItems chosenMenuItems:(NSMutableArray *)chosenMenuItems
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.restaurantMenuItems = [[NSArray alloc] initWithArray:restaurantMenuItems];
        self.searchResults = [[NSMutableArray alloc] initWithArray:restaurantMenuItems];
        self.chosenItems = [[NSMutableArray alloc] initWithArray:chosenMenuItems];
    }
    
    return self;
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

- (void) showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void) removeAnimate
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        
        if(shouldAnimate) {
            [self showAnimate];
        }
    });
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
    if(self.selectedRow && [self.selectedRow isEqual:indexPath]) {
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
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAddingNewItems:(id)sender {
}

- (IBAction)cancelAddingNewItems:(id)sender {
}
@end
