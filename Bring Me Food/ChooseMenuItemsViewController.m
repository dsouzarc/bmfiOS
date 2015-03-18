//
//  ChooseMenuItemsViewController.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ChooseMenuItemsViewController.h"
#import "RestaurantItem.h"

@interface ChooseMenuItemsViewController ()

- (IBAction)doneAddingNewItems:(id)sender;
- (IBAction)cancelAddingNewItems:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchTextView;
@property (strong, nonatomic) IBOutlet UITableView *menuItemsTableView;

@property (strong, nonatomic) NSArray *restaurantMenuItems;
@property (strong, nonatomic) NSMutableArray *chosenItems;

@end

@implementation ChooseMenuItemsViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil restaurantMenuItems:(NSArray *)restaurantMenuItems chosenMenuItems:(NSMutableArray *)chosenMenuItems
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.restaurantMenuItems = restaurantMenuItems;
        self.chosenItems = chosenMenuItems;
        NSLog(@"COUNT ME: %li", (long)self.restaurantMenuItems.count);
    }
    
    return self;
}

- (void)viewDidLoad
{
    /*self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.shadowOpacity = 0.8;
    self.mainView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);*/
    
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

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.menuItemsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    RestaurantItem *item = (RestaurantItem*)[self.restaurantMenuItems objectAtIndex:indexPath.row];
    
    NSLog(item.description);
    
    cell.textLabel.text = item.itemName;
    cell.detailTextLabel.text = item.itemDescription;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurantMenuItems.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAddingNewItems:(id)sender {
}

- (IBAction)cancelAddingNewItems:(id)sender {
}
@end
