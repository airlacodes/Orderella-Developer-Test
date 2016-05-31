//
//  PageContentViewController.m
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import "PageContentViewController.h"
#import "OrderItemTableViewCell.h"
#import "ServiceChargeTableViewCell.h"
#import "NSDate+RelativeTime.h"
#import "OrderItem.h"
#import "APIClient.h"
#import "UIImageView+Rotate.h"

@interface PageContentViewController () <UITableViewDataSource, UITableViewDelegate>

/* for the list of items in the current order */
@property (weak, nonatomic) IBOutlet UITableView *itemDataTableView;

/* shows the created date for the order and a time friendly string ie 31/05/16 - Yesterday */
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

/* the name of the bar */
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

/* where in the bar the user is located */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

/* the current status of the order (ie ready, delivered, waiting) */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/* the icon for the current status - which may also spin depending on status */
@property (weak, nonatomic) IBOutlet UIImageView *statusImge;

/* the total value of the order + service charge located under the TableView */
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;

@end

@implementation PageContentViewController {
    NSArray *_itemData;
    APIClient *apiClient;
    NSNumberFormatter *currencyFormat;
}

#pragma  mark - viewDid

- (void)viewDidLoad {
    [super viewDidLoad];
    apiClient = [[APIClient alloc] init];
    _itemDataTableView.dataSource = self;
    _itemDataTableView.delegate = self;

    // remove extra separators from tableview
    _itemDataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // array of the items inside the current order
    _itemData = [[[NSArray alloc] initWithArray:self.orderObject.orderedItems]mutableCopy];

    // create the number formatter for displaying price value with currency symbol
    currencyFormat = [[NSNumberFormatter alloc] init];
    [currencyFormat setNumberStyle: NSNumberFormatterCurrencyStyle];

    //map out self.orderObject to the interface
    [self setupOrder];

    // reload the items
    [_itemDataTableView reloadData]; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    // avoid rotating bug on the next image by setting rotation in view did appear
    [self rotateImage:[apiClient iconShouldRotate:self.orderObject.status]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];

    // stop rotating the current icon when moving to the next view controller (improves performance)
    [_statusImge stopAllAnimations];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return _itemData.count;
    }
    // only one optional service charge cell if there is one
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // section 0 = list of ordered items in the current order, section 1 is the optional service charge as the cells may have a different layout
    if (indexPath.section == 0) {
        OrderItemTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"orderItemCell"];
        OrderItem *item = _itemData[indexPath.row];

        tableCell.nameLabel.text = item.name;
        NSString *priceString = [currencyFormat stringFromNumber:[NSNumber numberWithFloat:item.price]];
        tableCell.priceLabel.text = [NSString stringWithFormat:@"%d x   %@", item.quantity, priceString];

        return tableCell;
    }
    // section 1 (set up the optional service cell)
    ServiceChargeTableViewCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:@"serviceChargeCell"];
    serviceCell.title.text = [NSString stringWithFormat:@"Optional Service Charge (%.02f%%)", self.orderObject.tip];

    serviceCell.sericeChargeTotal.text = [currencyFormat stringFromNumber:[NSNumber numberWithFloat:[APIClient serviceCharge:self.orderObject.total tipPercent:self.orderObject.tip]]];
    return serviceCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // if there is no service charge, ommit it from the interface (spefication instruction)
    if (self.orderObject.tip > 0) {
        return 2;
    }
    return 1;
}

#pragma mark - UI
/* fill all the labels */
- (void)setupOrder {
    _statusLabel.text = [apiClient statusDisplayForDelivery:self.orderObject.deliveryType status:self.orderObject.status]; 
    _orderTotalLabel.text = [currencyFormat stringFromNumber:[NSNumber numberWithFloat:self.orderObject.total]];
    _statusImge.image = [UIImage imageNamed:[NSString stringWithFormat:@"status_%@", self.orderObject.status]];
    _venueLabel.text = [self.orderObject.location objectForKey:@"name"];
    _locationLabel.text = [self.orderObject.locationArea objectForKey:@"name"];
    NSDate *relDate = [apiClient dateFromISO8601String:self.orderObject.createdOn];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _createdDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [relDate relativeTime], [dateFormatter stringFromDate:relDate]];
}

/* rotate the status icon */
- (void)rotateImage:(BOOL)rotate {
    if (!rotate) return;
    [_statusImge rotate360WithDuration:1.5 repeatCount:0];
}

@end
