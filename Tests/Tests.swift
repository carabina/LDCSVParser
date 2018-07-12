//
//  Tests.swift
//  Tests
//
//  Created by App Center on 7/11/18.
//  Copyright © 2018 L. Davis Development. All rights reserved.
//

import XCTest
@testable import LDCSVParser

class Tests: XCTestCase {
    
    var parser: CSVParser!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let csv = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
        parser = CSVParser(with: csv)
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCSV() {
        if let keyed = parser.keyedRows {
            do {
                try parser.build(with: keyed) { (people: [Person]) in
                    let p1 = people.first!
                    XCTAssertEqual(p1.name, "Alice")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
