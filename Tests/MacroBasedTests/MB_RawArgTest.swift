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

/// Test basic types, `B`: String, Int, Double and CmdArgEnum
/// Test that values are properly assigned to `B`,  `Array<B>`,  and `Variadic<B>` with and  wtihout
/// default values. Test `Optional<B>` witn (implied) default value of nil (other default values are
/// not allowed).
struct MB_RawArgTestsMain{

    @MainFunctionMacro
    static func rawArgs(
        // Optional parameters - have default value (implicit nil for argm)
        arg: RawArg = RawArg(parameterName: "argd", value: "0"),
        arga: [RawArg] = [],
        argv: Variadic<RawArg> = [],
        argm: RawArg? = nil,
        // Required parameters - no default value
        rarg: RawArg,
        rarga: [RawArg],
        rargv: Variadic<RawArg>) throws
    {
        // Required arguments
        let line = "----------------"
        var output: [String] = []
        output.append(rarg.value)
        output.append(rarga.map(\.value).joined(separator: " "))
        output.append(rargv.map(\.value).joined(separator: " "))

       // Optional arguments
        output.append(line)
        output.append(arg.value)
        if !arga.isEmpty {
            output.append(rarga.map(\.value).joined(separator: " "))
        }
        if !argv.isEmpty {
            output.append(rargv.map(\.value).joined(separator: " "))
        }
        if let argm {
            output.append(argm.value)
        }
        throw Exception.stdout(output.joined(separator: "\n"))
    }
}

let rawArgRequired = "--rarg 1 --rarga aa1 --rarga aa2  --rargv vv1 vv2 vv3"

@Suite(.serialized)
struct MB_RawArgTests {

    @Test func test1() async throws {
        let input = rawArgRequired
        let expected = """
        1
        aa1 aa2
        vv1 vv2 vv3
        ----------------
        0
        """
        let ok = testOutput(of: MB_RawArgTestsMain.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test2() async throws {
        let input = rawArgRequired + #" --arg 3 --arga aa1 --arga aa2 --argv vv1 vv2 vv3 --argm mm"#
        let expected = """
        1
        aa1 aa2
        vv1 vv2 vv3
        ----------------
        3
        aa1 aa2
        vv1 vv2 vv3
        mm
        """
        let ok = testOutput(of: MB_RawArgTestsMain.run, with: input, expecting: expected)
        #expect(ok)
    }
}
