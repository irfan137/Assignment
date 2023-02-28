//
//  _0230228_IrfanMohammed_ChaseTests.swift
//  20230228-IrfanMohammed-ChaseTests
//
//  Created by Irfan Mohammed on 2/28/23.
//

import XCTest
@testable import _0230228_IrfanMohammed_Chase

final class _0230228_IrfanMohammed_ChaseTests: XCTestCase {
    var model = ViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    /// Test Service call for city given as string to the API
    func testCityResults() {
        let exp = expectation(description: "SuccessResponse")
        model.addCitiesResults(city: "Frisco") {  _ in
            XCTAssert(self.model.status == 200)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    /// Test Service call for current city given as latitude and longitude to the API
    func testGetCurrentCityResults() {
        let exp = expectation(description: "SuccessResponse")
        model.getCurrentCityResult(lat: 77, lon: 2222) {  _ in
            XCTAssert(self.model.status == 200)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }
    
}
