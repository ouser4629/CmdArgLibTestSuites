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

struct RequiredOptions {

    // We use enum so we can get value errors
    enum Color: String, CmdArgEnum { case red, blue, yellow }

    struct BasicType {

        @MainFunctionMacro
        func basicType(f: Flag, l__left left: Color,  r__right right: Color) throws {
            let output = [ "f: \(f)", "left: \(left)", "right: \(right)" ]
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "-r white"
            let expected = """
            Errors:
              missing an occurrence of the "-l/--left" option
              "white" is not a valid <color> after -r
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f -r red --left blue"
            let expected = """
            f: true
            left: blue
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-fr red --left blue"
            let expected = """
            f: true
            left: blue
            right: red
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
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
        func optionalArguments(f: Flag, l__left lefts: [Color],  r__right rights: [Color]) throws {
            var output: [String] = [ "f: \(f)" ]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "-r white --right black"
            let expected = """
            Errors:
              missing an occurrence of the "-l/--left" option
              "white" is not a valid <color> after -r
              "black" is not a valid <color> after --right
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test2() throws {
            let input = "-f -r red -r yellow --left blue --left=yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test3() throws {
            let input = "-fr red -r yellow --left blue --left=yellow"
            let expected = """
            f: true
            lefts: blue, yellow
            rights: red, yellow
            """
            let ok = testOutput(of: run, with: input, expecting: expected)
            #expect(ok)
        }

        @Test func test4() throws {
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
        func optionalArguments(f: Flag, l__lefts lefts: Variadic<Color>,  r__rights rights: Variadic<Color>) throws {
            var output: [String] = [ "f: \(f)" ]
            output.append("lefts: \(lefts.map{"\($0)"}.joined(separator: ", "))")
            output.append("rights: \(rights.map{"\($0)"}.joined(separator: ", "))")
            throw Exception.stdout(output.listed)
        }

        @Test func test1() throws {
            let input = "-r white black white 3"
            let expected = """
            Errors:
              missing an occurrence of the "-l/--lefts" option
              "white" is not a valid <color> after -r
              "black" is not a valid <color> after -r
              "white" is not a valid <color> after -r
              "3" is not a valid <color> after -r
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
