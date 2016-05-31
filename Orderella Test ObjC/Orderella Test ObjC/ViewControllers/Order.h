//
//  Order.h
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"

/*
 {
	"code": "DRE",
	"tip": 12.5,
	"orderedItems": [{
 "item": {
 "id": 243,
 "name": "Fosters",
 "price": 4.5
 },
 "quantity": 1
	}],
	"createdOn": "2016-04-25T10:08:15+0100",
	"deliveryType": "pickup",
	"status": "preparing",
	"total": 5.06,
	"location": {
 "id": 12,
 "name": "Swan Tavern"
	},
	"locationArea": {
 "id": 9,
 "name": "Upstairs"
	}
 */

@interface Order : NSObject
@property (nonatomic) NSString *code;
@property (nonatomic) float tip;
@property (nonatomic) float preServiceTotal; 
@property (nonatomic) NSMutableArray *orderedItems;
@property (nonatomic) NSString *createdOn;
@property (nonatomic) NSString *deliveryType;
@property (nonatomic) NSString *status;
@property (nonatomic) float total;
@property (nonatomic) NSMutableDictionary *location;
@property (nonatomic) NSMutableDictionary *locationArea;
@end



