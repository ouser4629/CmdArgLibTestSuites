//  Copyright (c) 2025-2026 Psummerland2 LLC.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibTestSupport
import Foundation
import Testing

struct ShadowGroups {

    enum Color: String, CmdArgEnum { case red, blue, yellow }

    @MainFunctionMacro(shadowGroups: ["flag color ints doubles"])
    func shadows(f flag: Flag, c color: Color?, i ints: [Int] = [], d doubles: Variadic<Double> = []) throws {
        var output: [String] = []
        if flag { output.append("flag: \(flag)") }
        if let color { output.append("color: \(color)") }
        for int in ints { output.append("int: \(int)") }
        for double in doubles { output.append("double: \(double)") }
        throw Exception.stdout(output.listed)
    }

    @Test func test1() throws {
        let input = ""
        let expected = """
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test2() throws {
        let input = "-f -c red"
        let expected = """
            color: red
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test3() throws {
        let input = "-c red -f"
        let expected = """
            flag: true
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test4() throws {
        let input = "-f -c red -i 1 -i 2"
        let expected = """
            int: 1
            int: 2
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test5() throws {
        let input = "-f -c red -i 1 -f -i 2"
        let expected = """
            int: 1
            int: 2
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test6() throws {
        let input = "-f -c red -i 1 -i 2 -d 10.0 20.0"
        let expected = """
            double: 10.0
            double: 20.0
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test7() throws {
        let input = "-f -d 10.0 20.0 -c blue"
        let expected = """
            color: blue
            """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }
}
