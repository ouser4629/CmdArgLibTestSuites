//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import Foundation
import Testing
import CmdArgLibCore
import CmdArgLibTestSupport

struct ShowMacroTest {

    @Test func test1() throws {
        let input = "-h"
        let expected = """
        DESCRIPTION
          Print parsed values of command line arguments.
        
        USAGE
          show-macros [-h] [--call-names-macro] [--label-macros] [--type-macros]
                      [-g <greeting>] [-n <full-name>] -c <color> -a <animal>...
        
        PARAMETERS
          -g <greeting>             The greeting to print (default: "Hello").
          -n/--name <full-name>     If specified, the name of the person to greet.
          -c/--color <color>        Append <color> to the array of colors (can be
                                    repeated).
          -a/--animals <animal>...  One or more animals (if specified).
        
        META-OPTIONS
          -h/-help/--help           Show this help screen.
          --call-names-macro        Show call name show macro expansion.
          --label-macros            Show label show macro expansion.
          --type-macros             Show type and element show macro expansion.
        """
        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }


    @Test func test12() throws {
        let input = ""
        let expected = """
        Errors:
          missing an occurrence of the "-c/--color" option
          missing an occurrence of the "-a/--animals" option
        See "show-macros --help" for more information.
        """

        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test3() throws {
        let input = "-c red -c blue -a cat dog"
        let expected = """
        greeting: Hello
        maybeName: nil
        color: [red, blue]
        animals: [cat, dog]
        """

        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test4() throws {
        let input = "--call-names-macro"
        let expected = """
          The call name is "show-macros"
        """

        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test5() throws {
        let input = "--label-macros"
        let expected = """
         * the shortest label of the "greeting" parameter is "-g"
         * the shortest label of the "greeting" parameter is "-g"
         * the shortest label of the "maybeName" parameter is "-n"
         * the shortest label of the "color" parameter is "-c"
         * the longest label of the "greeting" parameter is "-g"
         * the longest label of the "maybeName" parameter is "--name"
         * the longest label of the "color" parameter is "--color"
         * the joined labels of the "greeting" parameter is "-g"
         * the joined labels of the "maybeName" parameter is "-n/--name"
         * the joined labels of the "color" parameter is "-c/--color"
        """

        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func test6() throws {
        let input = "--type-macros"
        let expected = """
         * the type of the "greeting" parameter is "<greeting>"
         * the type of the "greeting" parameter is "<greeting>"
         * the type of the "name" parameter is "<full-name>?"
         * the type of the "colors" parameter is "[<color>]"
         * the type of the "animals" parameter is "<animal>..."
         * the type of the wrapped element of the "maybeName" parameter is "<full-name>"
         * the type of an element of the "colors" parameter is "<color>" 
         * the type of an element of the "animals" parameter is "<animal>"
        """

        let ok = testOutput(of: run, with: input, expecting: expected)
        #expect(ok)
    }
}
