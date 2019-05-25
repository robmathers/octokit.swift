//
//  LabelTests.swift
//  OctoKitTests
//
//  Created by Rob Mathers on 2019-05-25.
//  Copyright © 2019 nerdish by nature. All rights reserved.
//

import XCTest
import OctoKit

class LabelTests: XCTestCase {

    // MARK: Request Tests
    func testGetLabels() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "labels", statusCode: 200)
        let task = Octokit().labels(session, owner: "octocat", repository: "hello-world") { response in
            switch response {
            case .success(let labels):
                XCTAssertEqual(labels.count, 7)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
