//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import Foundation
import Testing
import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibTestSupport

/// Test basic types, `B`: String, Int, Double and CmdArgEnum
/// Test that values are properly assigned to `B`,  `Array<B>`,  and `Variadic<B>` with and  wtihout
/// default values. Test `Optional<B>` witn (implied) default value of nil (other default values are
/// not allowed).
struct SB_BasicMain<B:CmdArgBasicType>:CommandNodeStruct {
    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "sb-basic-main",
        embellishments: [
            .embellish("argv", typeName: "Variadic<\(B.self)>"),
            .embellish("rargv", typeName: "Variadic<\(B.self)>?"),
        ]
    )

    // Not required - have non-nil default value
    var arg: B = B.initFromString("0")!
    var arga: [B] = []
    var argv: Variadic<B> = []
    var argm: B?? = .some(.none)

    // Required parameters - default value is nil
    var rarg: B? = nil
    var rarga: [B]? = nil
    var rargv: Variadic<B>? = nil

    func run(state: [Void]) throws -> [Void] {
        // Required arguments - have default value of nil
        // Can safely ! because parser will report an error if cannot
        // assign a value
        let line = "----------------"
        var output: [String] = []
        output.append("\(rarg!)")
        output.append(rarga!.map{"\($0)"}.joined(separator: " "))
        output.append(rargv!.map{"\($0)"}.joined(separator: " "))

       // Optional arguments - have default values
        output.append(line)
        output.append("\(arg)")
        if !arga.isEmpty {
            output.append(arga.map{"\($0)"}.joined(separator: " "))
        }
        if !argv.isEmpty {
            output.append(argv.map{"\($0)"}.joined(separator: " "))
        }
        // Due to Swift Optional coallesing, if let argm = argm! does not work
        if let argm, let argm {
            output.append("\(argm)")
        }
        throw Exception.stdout(output.joined(separator: "\n"))
    }
}

enum Token: String, CmdArgEnum {
    case zero = "0", one = "1", two = "2", three = "3", four
}

let stringRequired = "--rarg 1 --rarga aa1 --rarga aa2  --rargv vv1 vv2 vv3"
let numberRequired = "--rarg 1 --rarga 22 --rarga 33  --rargv 44 55 66"
let enumRequired = "--rarg 1 --rarga 2 --rarga 2  --rargv 3 3 3"

@Suite(.serialized)
struct SB_BasicTests {

    @Test func testString1() async throws {
        let input = stringRequired
        let expected = """
        1
        aa1 aa2
        vv1 vv2 vv3
        ----------------
        0
        """
        let ok = await testOutput(of: SB_BasicMain<String>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testString2() async throws {
        let input = stringRequired + #" --arg 1 --arga aa1 --arga aa2 --argv vv1 vv2 vv3 --argm mm"#
        let expected = """
        1
        aa1 aa2
        vv1 vv2 vv3
        ----------------
        1
        aa1 aa2
        vv1 vv2 vv3
        mm
        """
        let ok = await testOutput(of: SB_BasicMain<String>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testInt1() async throws {
        let input = numberRequired
        let expected = """
        1
        22 33
        44 55 66
        ----------------
        0
        """
        let ok = await testOutput(of: SB_BasicMain<Int>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testInt2() async throws {
        let input = numberRequired + #" --arg 1 --arga 22 --arga 33 --argv 44 55 66 --argm 77"#
        let expected = """
        1
        22 33
        44 55 66
        ----------------
        1
        22 33
        44 55 66
        77
        """
        let ok = await testOutput(of: SB_BasicMain<Int>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testDouble1() async throws {
        let input = numberRequired
        let expected = """
        1.0
        22.0 33.0
        44.0 55.0 66.0
        ----------------
        0.0
        """
        let ok = await testOutput(of: SB_BasicMain<Double>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testDouble2() async throws {
        let input = numberRequired + #" --arg 1 --arga 22 --arga 33 --argv 44 55 66 --argm 77"#
        let expected = """
        1.0
        22.0 33.0
        44.0 55.0 66.0
        ----------------
        1.0
        22.0 33.0
        44.0 55.0 66.0
        77.0
        """
        let ok = await testOutput(of: SB_BasicMain<Double>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testEnum1() async throws {
        let input = enumRequired
        let expected = """
        1
        2 2
        3 3 3
        ----------------
        0
        """
        let ok = await testOutput(of: SB_BasicMain<Token>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func testEnum2() async throws {
        let input = enumRequired + #" --arg 1 --arga 2 --arga 2 --argv 3 3 3 --argm four"#
        let expected = """
        1
        2 2
        3 3 3
        ----------------
        1
        2 2
        3 3 3
        four
        """
        let ok = await testOutput(of: SB_BasicMain<Token>.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }
}
