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
    static var allTests = [
        ("testGetLabels", testGetLabels),
        ("testGetLabelsSetsPagination", testGetLabelsSetsPagination),
        ("testParsingLabel", testParsingLabel),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

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
    
    func testGetLabelsSetsPagination() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=2&per_page=50", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let task = Octokit().labels(session, owner: "octocat", repository: "hello-world", page: "2", perPage: "50") { response in
            switch response {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    
    // MARK: Parsing Tests
    func testParsingLabel() {
        let label = Helper.codableFromFile("label", type: Label.self)
        XCTAssertEqual(label.name, "bug")
        XCTAssertEqual(label.color, "fc2929")
        XCTAssertEqual(label.url, URL(string: "https://api.github.com/repos/octocat/hello-worId/labels/bug")!)
    }

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if os(iOS)
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #else
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
