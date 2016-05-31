//
//  ViewController.m
//  Orderella Test ObjC
//
//  Created by Jeevan Thandi on 28/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import "ViewController.h"
#import "PageContentViewController.h"
#import "EmptyDataViewController.h"
#import "APIClient.h"
#import "Order.h"
@interface ViewController () <UIPageViewControllerDataSource>

/*provides the mechanism for swiping orders */
@property (strong, nonatomic) UIPageViewController *pageViewController;

/*an array of 'Order' objects for the Pageviews data source */
@property (strong, nonatomic) NSArray *orderList;

@end

@implementation ViewController {
    NSString *emptyDataReason;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // get recent orders for pageViewController datasource
    APIClient *api = [[APIClient alloc] init];
    [api getListOfOrderObjects:^(NSArray *results, NSError *error, NSString *errorReason){
        if (error) {
            // prepares an error for the EmptyDataViewController
            emptyDataReason = errorReason;
            return;
        }
        _orderList = [[NSArray alloc] initWithArray:results];
    }];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;

    // create page content view at first order object
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];

    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];

    // add the page view to the current View Controller (Root View)
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;

    if (index == [_orderList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [_orderList count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([_orderList count] == 0) || (index >= [_orderList count])) {
        EmptyDataViewController *emptyDataView = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyDataViewID"];
        emptyDataView.errorDisplay = emptyDataReason;
    
        return emptyDataView;
    }

    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.orderObject = _orderList[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

@end
