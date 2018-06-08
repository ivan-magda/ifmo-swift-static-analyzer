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

final class SwiftFileTreeWalker: FileTreeWalker {

    let path: String
    let fileManager: FileManager

    var iterator: AnyIterator<String> {
        var files = stackOfFiles
        return AnyIterator {
            return files.pop()
        }
    }

    var count: Int {
        return stackOfFiles.count
    }

    private var stackOfFiles: Stack<String> {
        do {
            return try Stack(array: findSwiftFiles(at: path))
        } catch {
            return Stack()
        }
    }

    // MARK: Init

    init(path: String, fileManager: FileManager = FileManager.default) {
        self.path = path
        self.fileManager = fileManager
    }

    // MARK: Private API

    private func findSwiftFiles(at path: String) throws -> [String] {
        var stack = try Stack(array: subpaths(at: path))
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
    }

    private func subpaths(at path: String) throws -> [String] {
        return try fileManager
            .contentsOfDirectory(atPath: path)
            .map { path.stringByAppendingPathComponent(path: $0).standardizingPath }
            .filter { !$0.isGitSpecificFile }
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
