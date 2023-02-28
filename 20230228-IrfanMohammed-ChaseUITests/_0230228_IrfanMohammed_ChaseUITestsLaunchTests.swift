//
//  _0230228_IrfanMohammed_ChaseUITestsLaunchTests.swift
//  20230228-IrfanMohammed-ChaseUITests
//
//  Created by Irfan Mohammed on 2/28/23.
//

import XCTest

final class _0230228_IrfanMohammed_ChaseUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
