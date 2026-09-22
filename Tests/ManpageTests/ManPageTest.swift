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
import CmdArgLibTestSupport

struct ManpageTest {

    @Test func manpage() throws {
        let input = "--generate-manpage"
        let expected = """
        .Dd September 13, 2026
        .Dt PERSON-M 1
        .Os 
        .Sh NAME
        .Nm person-m
        .Nd collect and print a person's personal information
        .Sh SYNOPSIS
        .Nm person-m
        [-lu]
        .Eo \\&[  Fl c Ar int Ec ]
        .Eo \\&[  Fl w Ar double Ec ]
        .Eo \\&[  Fl s Ar pet Ns ... Ec ]
        .Eo \\&[  Fl d Ar pet Ec ]
        .Ar name
        .Op Fl -generate-manpage
        .Sh DESCRIPTION
        Collect and print a person's personal information.
        .Sh OPTIONS
        .Bl -tag -width indent
        .It Fl l
        Lowercase the output.
        .It Fl u
        Uppercase the output.
        .It Fl c, Fl -count Ar int
        Print the output n times where n is the absolute value of the 
        .Ar int No  passed
        to 
        .Fl c/--count Ns . If the 
        .Ar int No  is negative the data is listed in reverse order. (default: 1).
        .El
        .Sh PERSONAL INFORMATION
        .Bl -tag -width indent
        .It Fl w, Fl -weight Ar double
        The person's weight in kgs.
        .It Fl s, Fl -son-has Ar pet Ns ...
        One or more of the pets owned by the person's son.
        .It Fl d, Fl -daughter-has Ar pet
        A pet owned by the person's daughter (can be repeated).
        .It  Ar name
        The person's name.
        .El
        .Sh PETS
        .Bl -tag -width indent
        .It Sy bird
        A bird is colorful, intelligent, vibrant and highly social.
        .It Sy cat
        A cat is agile, curious and cuddly.
        .It Sy dog
        A dog is man's best friend.
        .El
        .Sh NOTES
        The 
        .Fl u No  and 
        .Fl l No  flags shadow each other; the last 
        one encountered determines the formatting.
        There is a hidden meta-option, 
        .Fl -generate-completion-script No  
        .Ar shell Ns ,
        where 
        .Ar shell No  can be one of "zsh" or "fish". If specified,
        a corresponding completion script is printed to standard output.
        """
        let ok = testOutput(of: Manpage.run, with: input, expecting: expected)
        #expect(ok)
    }
}
