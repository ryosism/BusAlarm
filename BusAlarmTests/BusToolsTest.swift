//
//  BusToolsTest.swift
//  BusAlarmTests
//
//  Created by 祖父江亮 on 2018/09/08.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import XCTest

class BusToolsTest: XCTestCase {
    
    let busTools = BusTools()
    
    let testDates:[TestCase] = [
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 0), exceptedFileName: "closed"),
        // weekday
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*12), exceptedFileName: "someday"),
        // satuaday
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*8), exceptedFileName: "someday"),
        // holiday
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*9), exceptedFileName: "someday"),
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*16), exceptedFileName: "satuaday"),
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*3), exceptedFileName: "holiday"),
        TestCase(date: NSDate.init(timeIntervalSinceReferenceDate: 60*60*24*23), exceptedFileName: "rinzi")
    ]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        for testDate in testDates {
            let fileName:String = busTools.exceptionDateChecker(today: testDate.date, filename: "someday")
            print("\(testDate.date) = \(fileName), \(testDate.exceptedFileName)")
            XCTAssertEqual(fileName, testDate.exceptedFileName)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

struct TestCase {
    let date:NSDate
    let exceptedFileName:String
}
