/**
 * Copyright (c) 2018 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import SwiftLinterCore
import SourceKittenFramework
import XCTest

func violations(_ string: String) -> [StyleViolation] {
    return Linter(file: File(contents: string)).stringViolations
}

class LinterTests: XCTestCase {

    // MARK: Integration Tests

    func testThisFile() {
        XCTAssertEqual(violations(File(path: #file)!.contents), [])
    }

    // MARK: String Violations

    func testLineLengths() {
        let longLine = Array(repeating: "/", count: 100).joined()
        XCTAssertEqual(violations(longLine + "\n"), [])
        XCTAssertEqual(violations(longLine + "/\n"), [
            StyleViolation(
                type: .length,
                location: Location(file: nil, line: 1),
                reason: "Line #1 should be 100 characters or less: currently 101 characters")
            ]
        )
    }

    func testTrailingNewlineAtEndOfFile() {
        XCTAssertEqual(violations("//\n"), [])
        XCTAssertEqual(violations(""), [
            StyleViolation(
                type: .trailingNewline,
                location: Location(file: nil),
                reason: "File should have a single trailing newline: currently has 0")
            ]
        )
        XCTAssertEqual(violations("//\n\n"), [
            StyleViolation(
                type: .trailingNewline,
                location: Location(file: nil),
                reason: "File should have a single trailing newline: currently has 2")
            ]
        )
    }

    func testFileLengths() {
        let manyLines = Array(repeating: "//\n", count: 400).joined()
        XCTAssertEqual(violations(manyLines), [])
        XCTAssertEqual(violations(manyLines + "//\n"), [
            StyleViolation(
                type: .length,
                location: Location(file: nil),
                reason: "File should contain 400 lines or less: currently contains 401")
            ]
        )
    }

    func testFileShouldntStartWithWhitespace() {
        XCTAssertEqual(violations("//\n"), [])
        XCTAssertEqual(violations("\n"), [
            StyleViolation(
                type: .leadingWhitespace,
                location: Location(file: nil, line: 1),
                reason: "File shouldn't start with whitespace: currently starts with 1 whitespace " +
                "characters")
            ]
        )
        XCTAssertEqual(violations(" //\n"), [
            StyleViolation(
                type: .leadingWhitespace,
                location: Location(file: nil, line: 1),
                reason: "File shouldn't start with whitespace: currently starts with 1 whitespace " +
                "characters")
            ]
        )
    }

    func testLinesShouldntContainTrailingWhitespace() {
        XCTAssertEqual(violations("//\n"), [])
        XCTAssertEqual(violations("// \n"), [
            StyleViolation(
                type: .trailingWhitespace,
                location: Location(file: nil, line: 1),
                reason: "Line #1 should have no trailing whitespace: current has 1 trailing whitespace " +
                "characters")
            ]
        )
    }

    func testForceCasting() {
        XCTAssertEqual(violations("NSNumber() as? Int\n"), [])
        XCTAssertEqual(violations("NSNumber() as! Int\n"), [
            StyleViolation(
                type: .forceCast,
                location: Location(file: nil, line: 1),
                reason: "Force casts should be avoided")
            ]
        )
    }

}
