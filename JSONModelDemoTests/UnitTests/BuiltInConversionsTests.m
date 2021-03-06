//
//  BuiltInConversionsTests.m
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "BuiltInConversionsTests.h"
#import "BuiltInConversionsModel.h"

@implementation BuiltInConversionsTests
{
    BuiltInConversionsModel* b;
}

-(void)setUp
{
    [super setUp];
    
    NSString* filePath = [[NSBundle bundleForClass:[JSONModel class]].resourcePath stringByAppendingPathComponent:@"converts.json"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    XCTAssertNotNil(jsonContents, @"Can't fetch test data file contents.");
    
    NSError* err;
    b = [[BuiltInConversionsModel alloc] initWithString: jsonContents error:&err];
    XCTAssertNil(err, "%@", [err localizedDescription]);
    XCTAssertNotNil(b, @"Could not load the test data file.");
}

-(void)testConversions
{
    XCTAssertTrue(b.isItYesOrNo==YES, @"isItYesOrNo value is not YES");
    
    XCTAssertTrue(b.boolFromBoolean==YES, @"boolFromBoolean is not YES");
    XCTAssertTrue(b.boolFromNumber==YES, @"boolFromNumber is not YES");
    XCTAssertTrue(b.boolFromString==YES, @"boolFromString is not YES");
    
    
    XCTAssertTrue([b.unorderedList isKindOfClass:[NSSet class]], @"unorderedList is not an NSSet object");
    XCTAssertTrue([b.unorderedList anyObject], @"unorderedList don't have any objects");
    
    XCTAssertTrue([b.dynamicUnorderedList isKindOfClass:[NSMutableSet class]], @"dynamicUnorderedList is not an NSMutableSet object");
    XCTAssertTrue([b.dynamicUnorderedList anyObject], @"dynamicUnorderedList don't have any objects");

    NSUInteger nrOfObjects = [b.dynamicUnorderedList allObjects].count;
    
    [b.dynamicUnorderedList addObject:@"ADDED"];
    XCTAssertTrue(nrOfObjects + 1 == [b.dynamicUnorderedList allObjects].count, @"dynamicUnorderedList didn't add an object");
    
    XCTAssertTrue([b.stringFromNumber isKindOfClass:[NSString class]], @"stringFromNumber is not an NSString");
    XCTAssertTrue([b.stringFromNumber isEqualToString:@"19.95"], @"stringFromNumber's value is not 19.95");
    
    XCTAssertTrue([b.numberFromString isKindOfClass:[NSNumber class]], @"numberFromString is not an NSNumber");
    
    //TODO: I had to hardcode the float epsilon below, bcz actually [NSNumber floatValue] was returning a bigger deviation than FLT_EPSILON
    // IDEAS?
    XCTAssertTrue(fabsf([b.numberFromString floatValue]-1230.99)<0.001, @"numberFromString's value is not 1230.99");
    
    XCTAssertTrue([b.importantEvent isKindOfClass:[NSDate class]], @"importantEvent is not an NSDate");
    XCTAssertTrue((long)[b.importantEvent timeIntervalSince1970] == 1353916801, @"importantEvent value was not read properly");
    
    //test for a valid URL
    //https://github.com/icanzilb/JSONModel/pull/60
    XCTAssertNotNil(b.websiteURL, @"URL parsing did return nil");
    XCTAssertNotNil(b.websiteURL.query, @"key1=test");
}

@end
