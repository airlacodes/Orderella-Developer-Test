//
//  Orderella_TestTests.m
//  Orderella TestTests
//
//  Created by Jeevan Thandi on 31/05/2016.
//  Copyright © 2016 Airla Tech Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APIClient.h"
@interface Orderella_TestTests : XCTestCase

@end

@implementation Orderella_TestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/* Example test function - ideally I'd also write a function to test the JSON call in the APIClass to ensure correct keys are present  */
- (void)testPreServiceFormulaTest {
    float preService = [APIClient serviceCharge:5.06 tipPercent:12.50];
    XCTAssertEqualWithAccuracy(preService, 0.56, 0.01);
}


@end
