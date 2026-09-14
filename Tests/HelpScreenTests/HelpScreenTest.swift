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

struct HelpScreenTest {
    
    @Test func helpScreen80() async throws {
        let input = "-h"
        let expected = """
        DESCRIPTION
          Collect and print a person's personal information.
        
        USAGE
          person-s [-hlu] [-c <int>] [-w <double>] [-s <pet>...] [-d <pet>] <name>
        
        OPTIONS
          -h/--help                Show help information.
          -l                       Lowercase the output.
          -u                       Uppercase the output.
          -c/--count <int>         Print the output n times where n is the absolute
                                   value of the <int> passed to -c/--count. If the
                                   <int> is negative the data is listed in reverse
                                   order. (default: 1).
        
        PERSONAL INFORMATION
          -w/--weigth <double>     The person's weight in kgs.
          -s/--son-has <pet>...    One or more of the pets owned by the person's son.
          -d/--daughter-has <pet>  A pet owned by the person's daughter (can be
                                   repeated).
          <name>                   The person's name.
        
        PETS
          bird                     A bird is colorful, intelligent, vibrant and highly
                                   social.
          cat                      A cat is agile, curious and cuddly.
          dog                      A dog is man's best friend.
        
        NOTES
          The -u and -l flags shadow each other; the last one encountered determines
          the formatting.
        
          There is a hidden meta-option, "--generate-completion-script <shell>", where
          <shell> can be one of "zsh" or "fish". If specified, a corresponding
          completion script is printed to standard output.
        """
        let ok = await testOutput(of: PersonS.commandNode.run, with: input, expecting: expected)
        #expect(ok)
    }
}
