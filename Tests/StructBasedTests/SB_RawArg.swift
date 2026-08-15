//  Copyright (c) 2025-2026 Psummerland2 LLC.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibTestSupport
import Foundation
import Testing
import CmdArgLibCommandNodeStruct

struct SB_RawArgTestsMain: CommandNodeStruct {

    // Not required - have non-nil default value
    var arg: RawArg = RawArg(parameterName: "argd", value: "0")
    var arga: [RawArg] = []
    var argv: Variadic<RawArg> = []
    var argm: RawArg?? = .some(.none)

    // Reuired - have nil default value
    var rarg: RawArg? = nil
    var rarga: [RawArg]? = nil
    var rargv: Variadic<RawArg>? = nil

    
    var argd: RawArg = RawArg(parameterName: "argd", value: "default value for argd")

    func run(state: [Void]) throws -> [Void]
    {
        // Required arguments - have default value of nil
        // Can safely ! because parser will report an error if cannot
        // assign a value
        let line = "----------------"
        var output: [String] = []
        output.append("\(rarg!.value)")
        output.append(rarga!.map{"\($0.value)"}.joined(separator: " "))
        output.append(rargv!.map{"\($0.value)"}.joined(separator: " "))

        // Not required because they have default values
        output.append(line)
        output.append("\(arg.value)")
        if !arga.isEmpty {
            output.append(arga.map{"\($0.value)"}.joined(separator: " "))
        }
        if !argv.isEmpty {
            output.append(argv.map{"\($0.value)"}.joined(separator: " "))
        }
        // Due to Swift Optional coallesing, `if let argm = argm!` does not work
        if let argm, let argm {
            output.append("\(argm.value)")
        }
        throw Exception.stdout(output.joined(separator: "\n"))
    }

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "rawArgs",
        embellishments: [
            .embellish("argv", typeName: "Variadic<RawArg>"),
            .embellish("rargv", typeName: "Variadic<RawArg>?"),
        ]
    )
}

let rawArgRequired = "--rarg 1 --rarga aa1 --rarga aa2  --rargv vv1 vv2 vv3"

@Suite(.serialized)
struct SB_RawArgTests {

    @Test func test1() async throws {
        let input = rawArgRequired
        let expected = """
        1
        aa1 aa2
        vv1 vv2 vv3
        ----------------
        0
        """
        let ok = await testOutput(of: SB_RawArgTestsMain.commandNode.run, with: input, expecting: expected)
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
        let ok = await testOutput(of: SB_RawArgTestsMain.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }
}
