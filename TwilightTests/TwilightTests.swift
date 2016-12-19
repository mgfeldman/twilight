//
//  TwilightTests.swift
//  TwilightTests
//
//  Created by Mark on 12/10/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import XCTest
@testable import Twilight

class TwilightTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFormUrlString() {
        let location = CoordinateLocation(coordinateString: "37.77992308,-122.4697366")
        let request = WURequest(features: [.geolookup], location: location)
        
        let expectedRequestString = "http://api.wunderground.com/api/005ecab154b1d3ca/geolookup/q/37.77992308,-122.4697366.json"
        
        XCTAssertEqual(request.requestString, expectedRequestString)
    }
    
    func testFormUrlString_WithNilLocation() {
        var request = WURequest(features: [.geolookup], location: nil)
        request.useIpAddress = false
        XCTAssertNil(request.requestString)
    }
    
    func testFormUrlString_WithNilLocation_UseIpAddress() {
        let request = WURequest(features: [.geolookup], location: nil)
        XCTAssertNotNil(request.requestString)
    }
    
    func testFormUrlString_WithEmptyFeatures() {
        let request = WURequest(features: [], location: nil)
        XCTAssertNil(request.requestString)
    }
    
}
