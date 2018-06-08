# Swift Static Analyzer

`IFMO course project`

***SwiftLinter*** is a tool, that helps to enforce Swift style and conventions, based on [GitHub's Swift Style Guide](https://github.com/github/swift-style-guide).

**Supported Rules**:

- **Line length** should be 100 characters or less.
- **Leading whitespace** file shouldn't start with whitespace.
- **Force casts** should be avoided.
- **Trailing line whitespace** - lines should have no trailing whitespace.
- **Trailing new line** - file should have a single trailing newline.
- **File length** - file should contain 400 lines or less).

## Installation

Building SwiftLinter on macOS requires Xcode 9.4 or later or a Swift 4.1
toolchain or later with the Swift Package Manager.

### Swift Package Manager

Run `swift build` in the root directory of this project.

Debug:

```bash
$ swift build
$ .build/debug/SwiftLinter
```

Release:
```bash
$ swift build -c release -Xswiftc -static-stdlib
$ .build/release/SwiftLinter
```

## Usage

This will run SwiftLinter in the current directory containing the Swift files to lint. Directories will be searched recursively.

```bash
$ SwiftLinter
```

This will run SwiftLinter at the specified path to lint Swift files. Directories will be searched recursively.

```bash
$ SwiftLinter {YOUR_PATH}
```

## Screen Shot

![SwiftLinter](https://www.dropbox.com/s/dcdjtrfe4llqp0j/SwiftLinter.png?dl=1)
