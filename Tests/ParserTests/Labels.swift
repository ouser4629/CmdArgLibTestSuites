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

extension Array where Element == String {
    var listed: String { self.joined(separator: "\n") }
}

struct Labels {

    struct ShortLabels{

        @MainFunctionMacro
        func shortLabels(f: Flag, a ant: Flag, b__bee: Flag, w__wasp wasp: Flag) throws {
            let output: [String] = [
                "f: \(f)" , "ant: \(ant)", "bee: \(b__bee)", "wasp: \(wasp)",
            ]
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            f: false
            ant: false
            bee: false
            wasp: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-fabw"
            let expected = """
            f: true
            ant: true
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-f -a -b -w"
            let expected = """
            f: true
            ant: true
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
            let input = "--bee --wasp"
            let expected = """
            f: false
            ant: false
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct LongLabels{

        @MainFunctionMacro
        func longLabels(flag: Flag, antLabel ant: Flag, __bee bee: Flag, __waspLabel wasp: Flag) throws {
            let output: [String] = [
                "flag: \(flag)" , "ant: \(ant)", "bee: \(bee)", "wasp: \(wasp)",
            ]
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            flag: false
            ant: false
            bee: false
            wasp: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "--flag --ant-label --bee --wasp-label"
            let expected = """
            flag: true
            ant: true
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct OldStyleLabels{

        @MainFunctionMacro
        func longLabels(_flag_: Flag, _ant_ ant: Flag, b_bee_ bee: Flag, _wasp_wasp wasp: Flag) throws {
            let output: [String] = [
                "flag: \(_flag_)" , "ant: \(ant)", "bee: \(bee)", "wasp: \(wasp)",
            ]
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            flag: false
            ant: false
            bee: false
            wasp: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-flag -ant -bee -wasp"
            let expected = """
            flag: true
            ant: true
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-flag -ant -bee --wasp"
            let expected = """
            flag: true
            ant: true
            bee: true
            wasp: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct NonLabels{

        @MainFunctionMacro
        func nonLabels(f flag: Flag, _ant_ ant: Flag, bee: Flag) throws {
            let output: [String] = [
                "flag: \(flag)" , "ant: \(ant)", "bee: \(bee)",
            ]
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = ""
            let expected = """
            flag: false
            ant: false
            bee: false
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f -ant --bee"
            let expected = """
            flag: true
            ant: true
            bee: true
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-- -f -ant --bee"
            let expected = """
            Error:
              unassigned arguments: "-f", "-ant" and "--bee"
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }
}

