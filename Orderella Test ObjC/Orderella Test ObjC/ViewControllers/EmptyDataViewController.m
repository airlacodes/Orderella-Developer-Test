//
//  EmptyDataViewController.m
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 31/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import "EmptyDataViewController.h"

@interface EmptyDataViewController ()
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@end

@implementation EmptyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _descriptionLabel.text = self.errorDisplay;
}

@end
