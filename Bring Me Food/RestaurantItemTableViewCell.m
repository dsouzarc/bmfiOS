//
//  RestaurantItemTableViewCell.m
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/18/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "RestaurantItemTableViewCell.h"

@implementation RestaurantItemTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuItem:(RestaurantItem *)menuItem
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.menuItem = menuItem;
        
        self.itemName.text = menuItem.itemName;
        self.itemCost.text = menuItem.itemCost;
        self.itemDescription.text = menuItem.itemDescription;
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
