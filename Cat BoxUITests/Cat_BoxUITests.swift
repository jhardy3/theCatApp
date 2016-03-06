//
//  Cat_BoxUITests.swift
//  Cat BoxUITests
//
//  Created by Jake Hardy on 3/5/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import XCTest

class Cat_BoxUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let buttons = XCUIApplication().buttons
        let secondButton = buttons.elementBoundByIndex(4)
    
        snapshot("portraitCat")
        NSThread.sleepForTimeInterval(9)
        
        secondButton.tap()
        snapshot("CatImage")
        sleep(2)
        
        
    }
    
}
