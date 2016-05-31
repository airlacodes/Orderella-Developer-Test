//
//  APIClient.m
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import "APIClient.h"
#import "Order.h"
#import "OrderItem.h"
@implementation APIClient


- (void)getListOfOrderObjects:(ResultBlock)resultBlock {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"recentOrders" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:&jsonError];

    // will exequte call back if the json fails (unlikely when JSON is bundled in app - but necessary if remote
    if (jsonError) {
        resultBlock(nil, jsonError, @"There was a problem viewing your orders");
    }

    // begin to go through each item to parse out data and fill order object
    NSMutableArray *orderList = [NSMutableArray array];
    for (NSDictionary *order in json) {
        Order *orderObj = [[Order alloc] init];
        orderObj.code = [order objectForKey:@"code"];
        orderObj.tip = [[order objectForKey:@"tip"] floatValue];

        orderObj.createdOn = [order objectForKey:@"createdOn"];
        orderObj.deliveryType = [order objectForKey:@"deliveryType"];
        orderObj.status = [order objectForKey:@"status"];
        orderObj.total = [[order objectForKey:@"total"] floatValue];
        orderObj.location = [order objectForKey:@"location"];
        orderObj.locationArea = [order objectForKey:@"locationArea"];
        NSDictionary *orderedItems = [order objectForKey:@"orderedItems"];
        orderObj.orderedItems = [NSMutableArray array];

        // going deeper to get the items
        for(NSDictionary *data in orderedItems){
            NSDictionary *item = [data objectForKey:@"item"];

            OrderItem *orderItem = [[OrderItem alloc] init];
            orderItem.quantity = [[data objectForKey:@"quantity"] intValue];
            orderItem.idCode = [[item objectForKey:@"id"] intValue];
            orderItem.name = [item objectForKey:@"name"];
            orderItem.price = [[item objectForKey:@"price"] floatValue];

            [orderObj.orderedItems addObject:orderItem];
        }

        // order object now full, add it and the foor loop should add the next
        [orderList addObject:orderObj];
    }

    // execute call back with Array of data for PageViewController
    resultBlock(orderList, nil, nil);
}

#pragma mark - General Helpers

+ (float)serviceCharge:(float)price tipPercent:(float)tipPercent {
    // reverse percentage calculation - Included in sample Unit Test
    float percent = price / (tipPercent + 100);
    return percent * tipPercent;
}

-(NSDate *)dateFromISO8601String:(NSString *)dateString {
    if ([dateString hasSuffix:@"Z"]) {
        dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"-0000"];
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HHmmssZ";
    return [dateFormatter dateFromString:dateString];
}

- (BOOL)iconShouldRotate:(NSString *)status {
    if ([status isEqualToString:@"new"] || [status isEqualToString:@"preparing"]) {
        return YES;
    }
    return NO; 
}

// the alternative was a large if else statement. Ideally I'd like to make enum for status and some sort of string to enum check.
- (NSString *)statusDisplayForDelivery:(NSString *)deliveryType status:(NSString *)status {
    NSDictionary *pickUpDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"New", @"new",
                                                                        @"Received", @"preparing",
                                                                        @"Collected", @"delivered",
                                                                        @"Ready", @"ready",nil];

    NSDictionary *deliveryTableDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"New", @"new",
                                                                                 @"Received", @"preparing",
                                                                                 @"Delivered", @"delivered",
                                                                                 @"Ready", @"ready",nil];
    if ([deliveryType isEqualToString:@"pickup"]) {
        return [pickUpDictionary objectForKey:status];
    }
    // the PDF mentioned pickup + delivery but the json includes 'table' so this is to cover all basis
    return [deliveryTableDictionary objectForKey:status];
}
@end
