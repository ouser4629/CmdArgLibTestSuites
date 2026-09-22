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

