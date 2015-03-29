//
//  OrdersTableViewCell.h
//  Bring Me Food
//
//  Created by Ryan D'souza on 3/29/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderedOnDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
