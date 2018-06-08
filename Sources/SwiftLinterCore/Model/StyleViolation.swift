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

struct StyleViolation: CustomStringConvertible, Equatable {

    public let type: StyleViolationType
    public let severity: ViolationSeverity
    public let location: Location
    public let reason: String?

    public var description: String {
        return "\(location): " +
            "\(severity.xcodeSeverityDescription): " +
            "\(type) Violation (\(severity) Severity): " +
            (reason ?? "")
    }

    public init(type: StyleViolationType, location: Location, reason: String? = nil) {
        severity = .low
        self.type = type
        self.location = location
        self.reason = reason
    }

    // MARK: Equatable

    /**
     Returns true if `lhs` StyleViolation is equal to `rhs` StyleViolation.

     :param: lhs StyleViolation to compare to `rhs`.
     :param: rhs StyleViolation to compare to `lhs`.

     :returns: True if `lhs` StyleViolation is equal to `rhs` StyleViolation.
     */
    static public func == (lhs: StyleViolation, rhs: StyleViolation) -> Bool {
        return lhs.type == rhs.type &&
            lhs.location == rhs.location &&
            lhs.reason == rhs.reason
    }

}
