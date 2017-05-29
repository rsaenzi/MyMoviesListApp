//
//  MyMoviesListAppUITests.swift
//  MyMoviesListAppUITests
//
//  Created by Rigoberto Sáenz Imbacuán on 5/25/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import XCTest

class MyMoviesListAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
