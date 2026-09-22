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
