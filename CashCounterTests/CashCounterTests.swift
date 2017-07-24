//
//  CashCounterTests.swift
//  CashCounterTests
//
//  Created by Zohaib Aziz on 18/07/2017.
//  Copyright © 2017 NISUM. All rights reserved.
//

import XCTest
@testable import CashCounter

class CashCounterTests: XCTestCase {
    
    let mainView = ViewController()
    
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
        
        //Here we set a value for checking our method
        let testValue = 200
        
        let textBox = UITextField()
        textBox.text = "2"
        
        //passing values
        mainView.getDenominationValues(val: "$100", textField: textBox)
        
        //Here we Matched Our Values
        XCTAssert(Int(mainView.totalValue) == testValue)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
