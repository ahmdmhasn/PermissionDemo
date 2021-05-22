import XCTest

import PermissionTests

var tests = [XCTestCaseEntry]()
tests += PermissionTests.allTests()
XCTMain(tests)
