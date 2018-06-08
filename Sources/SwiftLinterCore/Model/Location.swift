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
import SourceKittenFramework

struct Location: CustomStringConvertible, Equatable {

    public let file: String?
    public let line: Int?
    public let character: Int?

    public var description: String {
        return (file ?? "<nopath>") +
            (line.map { ":\($0)" } ?? "") +
            (character.map { ":\($0)" } ?? "")
    }

    public init(file: String?, line: Int? = nil, character: Int? = nil) {
        self.file = file
        self.line = line
        self.character = character
    }

    public init(file: File, offset: Int) {
        self.file = file.path
        if let lineAndCharacter = file.contents.lineAndCharacterForByteOffset(offset: offset) {
            line = lineAndCharacter.line
            character = nil
        } else {
            line = nil
            character = nil
        }
    }

    // MARK: Equatable

    /**
     Returns true if `lhs` Location is equal to `rhs` Location.

     :param: lhs Location to compare to `rhs`.
     :param: rhs Location to compare to `lhs`.

     :returns: True if `lhs` Location is equal to `rhs` Location.
     */
    static public func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.file == rhs.file &&
            lhs.line == rhs.line &&
            lhs.character == rhs.character
    }

}
