//
//  OrderItemTableViewCell.h
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 29/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@end
