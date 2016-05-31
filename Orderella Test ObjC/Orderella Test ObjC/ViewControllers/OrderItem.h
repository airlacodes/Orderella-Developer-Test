//
//  OrderItem.h
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 29/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property (nonatomic) int idCode;
@property (nonatomic) NSString *name;
@property (nonatomic) int quantity;
@property (nonatomic) float price; 
@end
