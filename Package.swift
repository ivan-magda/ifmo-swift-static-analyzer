// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLinter",
    dependencies: [
        .package(
        	url: "https://github.com/jpsim/SourceKitten.git",
        	from: "0.21.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftLinter",
            dependencies: [
            	"SwiftLinterCore"
            ]
        ),
        .target(
        	name: "SwiftLinterCore",
        	dependencies: [
        		"SourceKittenFramework"
        	]
        ),
        .testTarget(
        	name: "SwiftLinterTests",
        	dependencies: [
        		"SwiftLinterCore",
        		"SourceKittenFramework"
        	]
        )
    ]
)
