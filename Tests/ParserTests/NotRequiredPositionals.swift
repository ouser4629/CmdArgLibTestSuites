//  Copyright (c) 2025-2026 Psummerland2 LLC.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import Foundation
import Testing
import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibTestSupport

struct NotRequiredPositionals {

    // We use enum so we can get value errors
    enum Color: String, CmdArgEnum { case red, blue, yellow }

    struct BasicType {

        @MainFunctionMacro
        func basicType(f: Flag, _ left: Int?,  _ right: Color?) throws {
            var output = ["f: \(f)"]
            if let left { output.append("left: \(left)")}
            if let right { output.append("right: \(right)") }
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "42 red"
            let expected = """
            f: false
            left: 42
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "42 -f red"
            let expected = """
            f: true
            left: 42
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = ""
            let expected = """
            f: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
            let input = "42"
            let expected = """
            f: false
            left: 42
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test5() throws {
            let input = "red"
            let expected = """
            Error:
              "red" is not a valid <int>
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test6() throws {
            let input = "42 red white"
            let expected = """
            Error:
              unassigned argument: "white"
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test7() throws {
            let input = "42.0 white red"
            let expected = """
            Errors:
              unassigned argument: "red"
              "42.0" is not a valid <int>
              "white" is not a valid <color>
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct ArrayOfBasicType {

        // Note that positional array parameters look like variadic, but they
        // are really just repeated array arguments. E.g., "1 2 -f red blue"
        // would have to be "--lefts l --lefts 2 -f --rights red" if the
        // labels were not "_".
        @MainFunctionMacro
        func optionalArguments(f: Flag, _ lefts: [Int], _ rights: [Color]) throws {
            var output: [String] = [ "f: \(f)"]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        // Other parsers would not respect the -f. Hence report red is bad int.
        @Test func test1() throws {
            let input = "1 2 -f red blue"
            let expected = """
            f: true
            lefts: 1, 2
            rights: red, blue
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "1 2 red blue"
            let expected = """
            Errors:
              missing value: "<color>"
              "red" is not a valid <int>
              "blue" is not a valid <int>
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "1 2 -f red -f blue"
            let expected = """
            Error:
              unassigned argument: "blue"
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }


    struct VariadicBasicType {

        @MainFunctionMacro
        func optionalArguments(f: Flag, _ lefts: Variadic<Int>,  _ rights: Variadic<Color>) throws {
            var output: [String] = [ "f: \(f)" ]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        // Other parsers would not respect the -f. Hence report red is bad int.
        @Test func test1() throws {
            let input = "1 2 -f red blue"
            let expected = """
            f: true
            lefts: 1, 2
            rights: red, blue
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "1 2 red blue"
            let expected = """
            Errors:
              missing value: "<color>"
              "red" is not a valid <int>
              "blue" is not a valid <int>
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "1 2 -f red -f blue"
            let expected = """
            Error:
              unassigned argument: "blue"
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }
}
