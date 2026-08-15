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

struct NotRequiredOption {

    // We use enum so we can get value errors
    enum Color: String, CmdArgEnum { case red, blue, yellow }

    struct BasicBasicType {

        @MainFunctionMacro
        func OptionalType(f: Flag, l__left left: Color?,  r__right right: Color?) throws {
            var output = ["f: \(f)"]
            if let left { output.append("left: \(left)")}
            if let right { output.append("right: \(right)") }
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            f: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-r white"
            let expected = """
            Error:
              "white" is not a valid <color> after -r
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-f -r red --left blue"
            let expected = """
            f: true
            left: blue
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
            let input = "-fr red --left blue"
            let expected = """
            f: true
            left: blue
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test5() throws {
            let input = "-frred --left blue"
            let expected = """
            f: true
            left: blue
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

    }

    struct ArrayOfBasicType {

        @MainFunctionMacro
        func optionalArguments(f: Flag, l__left lefts: [Color] = [],  r__right rights: [Color] = []) throws {
            var output: [String] = [ "f: \(f)" ]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            f: false
            lefts: 
            rights: 
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-r white --right black"
            let expected = """
            Errors:
              "white" is not a valid <color> after -r
              "black" is not a valid <color> after --right
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-f -r red -r yellow --left blue --left=yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
            let input = "-fr red -r yellow --left blue --left=yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test5() throws {
            let input = "-frred -r yellow --left blue --left=yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct VariadicBasicType {

        @MainFunctionMacro
        func optionalArguments(f: Flag, l__lefts lefts: Variadic<Color> = [],  r__rights rights: Variadic<Color> = []) throws {
            var output: [String] = [ "f: \(f)" ]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "-r white black"
            let expected = """
            Errors:
              "white" is not a valid <color> after -r
              "black" is not a valid <color> after -r
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f -r red yellow --lefts blue yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-f -r red yellow --lefts=blue yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
            let input = "-fr red yellow --lefts blue yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test5() throws {
            let input = "-frred yellow --lefts blue yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test6() throws {
            let input = "-frred yellow --lefts blue yellow --rights yellow red"
            let expected = """
            Error:
              duplicate occurrences of the "-r/--rights" option
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }
}

