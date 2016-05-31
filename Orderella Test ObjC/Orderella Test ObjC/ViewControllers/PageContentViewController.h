//
//  PageContentViewController.h
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface PageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *titleText;
@property (nonatomic) Order *orderObject;
@end
