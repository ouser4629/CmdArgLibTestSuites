//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

// Include desired examples
let includeStuctBasedCode = true
var includeMacroBasedCode = true

// Include the samples that use CmdArgLibMacros only when built with
// Swift 6.2 or later. Earlier toolchains either do not support macros
// or have unacceptable macro build performance.
#if compiler(<6.2)
    includeMacroExamples = false
}
#endif

// Products
var products: [Product] = [
    .library(name: "TestSuiteSupport", targets: ["TestSuiteSupport"])
]
if includeStuctBasedCode {
    products += [
    ]
}
if includeMacroBasedCode {
    products += [
    ]
}

// Dependencies
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibTestSupport.git", branch: "main"),
]
if includeMacroBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"))
}
if includeStuctBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibCommandNodeStruct.git", branch: "main"))
}

// Shared targets
var targets: [Target] = [
    .target(
        name: "TestSuiteSupport",
        dependencies: [ "CmdArgLibCore"],
    ),
]

// Struct-base API targets
if includeStuctBasedCode {
    targets += [
        .testTarget(
            name:"StructBasedTests",
            dependencies: [
                "CmdArgLibCore","CmdArgLibCommandNodeStruct", "CmdArgLibTestSupport"
            ]
        )
    ]
}

// Macro-based API targets
if includeMacroBasedCode {
    targets += [

        // Special tests using CmdArgLibMacros
        .testTarget(
            name: "MacroBasedTests",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibTestSupport",
            ]
        ),
        .testTarget(
            name: "ParserTests",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibTestSupport",
            ]
        ),
    ]
}

// The package
let package = Package(
    name: "cmd-arg-lib",
    platforms: [.macOS(.v12)],
    products: products,
    dependencies: dependencies,
    targets: targets
)
