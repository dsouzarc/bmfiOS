//
//  RestaurantItemTableViewCell.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

@interface RestaurantItemTableViewCell : UITableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuItem:(RestaurantItem*)menuItem;

@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UITextView *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *itemCost;

@property (strong, nonatomic) RestaurantItem *menuItem;

@end
