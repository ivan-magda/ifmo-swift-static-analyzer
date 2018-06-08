//
//  File+ViolationExtensions.swift
//  ifmo-swift-static-analyzer
//
//  Created by Ivan Magda on 07/06/2018.
//  Copyright © 2018 Ivan Magda. All rights reserved.
//

import Foundation
import SourceKittenFramework

typealias Line = (index: Int, content: String)

// Violation Extensions

extension File {

    func lineLengthViolations(lines: [Line]) -> [StyleViolation] {
        return lines
            .filter({ $0.content.count > 100 })
            .map {
                return StyleViolation(
                    type: .length,
                    location: Location(file: self.path, line: $0.index),
                    reason: "Line #\($0.index) should be 100 characters or less: " +
                            "currently \($0.content.count) characters"
                )
        }
    }

    func leadingWhitespaceViolations(contents: String) -> [StyleViolation] {
        let countOfLeadingWhitespace = contents.countOfLeadingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if countOfLeadingWhitespace != 0 {
            return [StyleViolation(
                type: .leadingWhitespace,
                location: Location(file: self.path, line: 1),
                reason: "File shouldn't start with whitespace: " +
                        "currently starts with \(countOfLeadingWhitespace) whitespace characters"
                )
            ]
        }

        return []
    }

    func forceCastViolations(file: File) -> [StyleViolation] {
        do {
            let regex = try NSRegularExpression(pattern: "as!", options: .caseInsensitive)
            let range = NSRange(location: 0, length: file.contents.utf16.count)
            let syntax = try SyntaxMap(file: file)
            let matches = regex.matches(in: file.contents, options: .reportCompletion, range: range)

            let violations: [StyleViolation] = matches.compactMap { match in
                let offset = match.range.location
                let tokenAtOffset = syntax.tokens.filter({ $0.offset == offset }).first

                guard let type = tokenAtOffset?.type else {
                    return nil
                }

                if SyntaxKind(rawValue: type) != .keyword {
                    return nil
                }

                return StyleViolation(
                    type: .forceCast,
                    location: Location(file: self, offset: offset),
                    reason: "Force casts should be avoided"
                )
            }

            return violations
        } catch {
            return []
        }
    }

    func trailingLineWhitespaceViolations(lines: [Line]) -> [StyleViolation] {
        return lines.map { line in
            (
                index: line.index,
                trailingWhitespaceCount: line.content.countOfTailingCharacters(in: CharacterSet.whitespaces)
            )
            }.filter {
                $0.trailingWhitespaceCount > 0
            }.map {
                StyleViolation(
                    type: .trailingWhitespace,
                    location: Location(file: self.path, line: $0.index),
                    reason: "Line #\($0.index) should have no trailing whitespace: " +
                            "current has \($0.trailingWhitespaceCount) trailing whitespace characters"
                )
        }
    }

    func trailingNewlineViolations(contents: String) -> [StyleViolation] {
        let countOfTrailingNewlines = contents.countOfTailingCharacters(in: CharacterSet.newlines)

        if countOfTrailingNewlines != 1 {
            return [
                StyleViolation(
                    type: .trailingNewline,
                    location: Location(file: self.path),
                    reason: "File should have a single trailing newline: " +
                            "currently has \(countOfTrailingNewlines)"
                )
            ]
        }

        return []
    }

    func fileLengthViolations(lines: [Line]) -> [StyleViolation] {
        if lines.count > 400 {
            return [
                StyleViolation(
                    type: .length,
                    location: Location(file: self.path),
                    reason: "File should contain 400 lines or less: currently contains \(lines.count)"
                )
            ]
        }
        
        return []
    }

}
