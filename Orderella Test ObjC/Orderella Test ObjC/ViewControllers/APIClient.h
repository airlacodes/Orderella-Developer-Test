//
//  APIClient.h
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APIClient : NSObject

/* completion handler for the json fetch */
typedef void (^ResultBlock)(NSArray *objects, NSError *error, NSString *errorReason);

/* goes into  recentOrders.json and should return an array of Order objects */
- (void)getListOfOrderObjects:(ResultBlock)resultBlock;

/* does a reverse percentage calculation on the order to find the service charge value */
+ (float)serviceCharge:(float)price tipPercent:(float)tipPercent;

/* converts the ISO8601 string to a more typical NSDate: Taken from: http://stackoverflow.com/a/12545026 */
-(NSDate *)dateFromISO8601String:(NSString *)dateString;

/*returns YES/NO depending on whether the status icon should rotate (based on its status) */
- (BOOL)iconShouldRotate:(NSString *)status;

/* returns the correct display text for an order status depending on the delivery type EG: 

 For deliveryType=“delivery (table?)”: new - “New”
 preparing - “Received” delivered -“Delivered”

 For deliveryType=“pickup”: new - “New”
 preparing - “Received” ready - “Ready” delivered -“Collected”

 */

- (NSString *)statusDisplayForDelivery:(NSString *)deliveryType status:(NSString *)status;

@end
