// Copyright (c) 2025-2026 Peter Summerland LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// swift-tools-version: 6.2

//import CompilerPluginSupport
import PackageDescription

// Include desired examples
let includeStructBasedCode = true
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

// Dependencies
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibHelpScreen.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibManpage.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibCompletions.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibTestSupport.git", branch: "main"),
]
if includeMacroBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"))
}
if includeStructBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibCommandNodeFrame.git", branch: "main"))
}

// Shared targets
var targets: [Target] = [
    .target(
        name: "TestSuiteSupport",
        dependencies: [ "CmdArgLibCore"],
    ),
]

// Struct-base API targets
if includeStructBasedCode {
    targets += [
        .testTarget(
            name:"StructBasedTests",
            dependencies: [
                "CmdArgLibCore","CmdArgLibCommandNodeFrame", "CmdArgLibTestSupport"
            ]
        ),
        .testTarget(
            name: "HelpScreenTests",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibCommandNodeFrame", "CmdArgLibHelpScreen", "CmdArgLibCompletions", "CmdArgLibTestSupport",
            ]
        ),
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
        .testTarget(
            name: "ShowMacroTests",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen", "CmdArgLibTestSupport",
            ]
        ),
        .testTarget(
            name: "ManpageTests",
            dependencies: [
                "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibManpage", "CmdArgLibCompletions", "CmdArgLibTestSupport",
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
