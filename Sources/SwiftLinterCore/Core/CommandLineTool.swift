import Foundation

// MARK: CommandLineTool

public final class CommandLineTool {

    // MARK: Instance Variables

    private let arguments: [String]

    // MARK: Init

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
    }

    // MARK: Public API

    public func run() throws {
        guard arguments.count <= 2 else {
            throw Error.illegalArgumentsCount
        }

        let directoryName = arguments.count == 2
            ? arguments[1]
            : FileManager.default.currentDirectoryPath

        let linter = Linter(
            fileTreeWalker: SwiftFileTreeWalker(path: directoryName)
        )

        do {
            try linter.lint()
        } catch {
            throw Error.failedToLintFiles
        }
    }

}

// MARK: - CommandLineTool (Error) -

public extension CommandLineTool {
    enum Error: Swift.Error {
        case illegalArgumentsCount
        case failedToLintFiles
    }
}
