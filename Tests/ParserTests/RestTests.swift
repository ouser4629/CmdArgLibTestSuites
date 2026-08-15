//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
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

struct RestTests {

    struct RequiredRestTests {

        @MainFunctionMacro
        func shortLabels(f: Flag, r__rest rest:Rest) throws {
            var output: [String] = [ "f: \(f)"]
            output.append("rest: \(rest.elements.map{"\($0)"}.joined(separator: "|"))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "--rest -f -x --yy zz -- -a --bb cc"
            let expected = """
        f: false
        rest: -f|-x|--yy|zz|--|-a|--bb|cc
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f --rest -f -x --yy zz -- -a --bb cc"
            let expected = """
        f: true
        rest: -f|-x|--yy|zz|--|-a|--bb|cc
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = ""
            let expected = """
        Error:
          missing an occurrence of the "-r/--rest" option
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    struct NotRequiredRestTests {

        @MainFunctionMacro
        func shortLabels(f: Flag, r__rest rest: Rest = []) throws {
            var output: [String] = [ "f: \(f)"]
            output.append("rest: \(rest.elements.map{"\($0)"}.joined(separator: "|"))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "--rest -f -x --yy zz -- -a --bb cc"
            let expected = """
        f: false
        rest: -f|-x|--yy|zz|--|-a|--bb|cc
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f --rest -f -x --yy zz -- -a --bb cc"
            let expected = """
        f: true
        rest: -f|-x|--yy|zz|--|-a|--bb|cc
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = ""
            let expected = """
        f: false
        rest: 
        """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }
    }

}
