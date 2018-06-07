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

/// "Print lint warnings and errors for the Swift files in the current directory".
final class Linter {

    private let fileManager = FileManager.default

    // MARK: Public API

    func run() {
        print("Finding Swift files in current directory...\n")
        let files = findSwiftFiles(in: "/Users/ivanmagda/prog/projects/ifmo-swift-static-analyzer")
        for (index, file) in files.enumerated() {
            print("Linting '\(file.lastPathComponent)' (\(index + 1)/\(files.count))\n")
        }
    }

    // MARK: Private API

    private func subpaths(at path: String) throws -> [String] {
        return try fileManager
            .contentsOfDirectory(atPath: path)
            .map { path.stringByAppendingPathComponent(path: $0).standardizingPath }
            .filter { !$0.isGitSpecificFile }
    }

    private func findSwiftFiles(in directory: String) -> [String] {
        do {
            var stack = try Stack(array: subpaths(at: directory))
            var swiftFiles = [String]()

            while !stack.isEmpty {
                let subPath = stack.pop()!
                var isDir: ObjCBool = false

                if fileManager.fileExists(atPath: subPath, isDirectory: &isDir) {
                    if isDir.boolValue {
                        try stack.pushAll(subpaths(at: subPath))
                    } else {
                        if subPath.isSwiftFile {
                            swiftFiles.append(subPath)
                        }
                    }
                }
            }

            return swiftFiles
        } catch {
            print(error)
            return []
        }
    }

}

// MARK: - String (File Types) -

fileprivate extension String {

    var isSwiftFile: Bool {
        return self.lastPathComponent.hasSuffix(".swift")
    }

    var isGitSpecificFile: Bool {
        return self.lastPathComponent.hasPrefix(".git")
    }

}
