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


import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibCompletions
import CmdArgLibManpage

public typealias Name = String
public enum Pet: String, CmdArgEnum { case dog, cat, bird }

struct Manpage {
    typealias Shell = CompletionGenerator

    @MainFunctionMacro(shadowGroups: ["u l"])
    static func personM(
        l: Flag = false,
        u: Flag = false,
        c__count count: Int = 1,
        w__weight weight: Double? = nil,
        s__sonHas sonHas: Variadic<Pet> = [],
        d__daughterHas daughterHas: [Pet] = [],
        _ name: Name,
        generateManpage: MetaFlag = MetaFlag(manpageElements: manpageLayout),
        generateCompletionScript: MetaOption<Shell> = MetaOption(generator) )
    {
        var lines: [String] = []
        if let weight { lines.append("  \(name) weighs \(weight) kgs.") }
        if !sonHas.isEmpty  { lines.append("  \(name)'s son has \(sonHas.map{"a \($0)"}.joinedWith("and")).") }
        if !daughterHas.isEmpty  { lines.append("  \(name)'s daughter has \(daughterHas.map{"a \($0)"}.joinedWith("and")).") }
        if lines.isEmpty  { lines.append("  No data was found for \(name).") }
        if count < 0 { lines.reverse() }
        lines.insert("DATA:", at: 0)
        var line = lines.joined(separator: "\n")
        line = u ? line.uppercased() : l ? line.lowercased() : line
        for _ in 0..<abs(count) { print(line) }
    }

    static let generator = CompletionGenerator(name: "person-m", suggestionElements: manpageLayout)
}

private let manpageLayout: [ShowElement] = [
    .prologue(description: "collect and print a person's personal information",
              date: "September 13, 2026"),
    .synopsis(line: ["!generateCompletionScript"]),
    .text("DESCRIPTION\n", "Collect and print a person's personal information."),
    .paragraph("\nOPTIONS"),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("count", countDescription),
    .paragraph("\nPERSONAL INFORMATION"),
    .parameter("weight", "The person's weight in kgs"),
    .parameter("sonHas", "One or more of the pets owned by the person's son", .list(Pet.cases)),
    .parameter("daughterHas", "A pet owned by the person's daughter (can be repeated)", .list(Pet.cases)),
    .parameter("name", "The person's name"),
    .paragraph("\nPETS"),
    .pseudoParameter("bird","A bird is colorful, intelligent, vibrant and highly social"),
    .pseudoParameter("cat","A cat is agile, curious and cuddly"),
    .pseudoParameter("dog", "A dog is man's best friend"),
    .paragraph("\nNOTES\n", note)
]

private let countDescription = """
    Print the output n times where n is the absolute value of the $T{count} passed
    to $J{count}. If the $T{count} is negative the data is listed in reverse order.
    """

private let note = """
    The $J{u} and $J{l} flags shadow each other; the last 
    one encountered determines the formatting.
    
    There is a hidden meta-option, $J{generateCompletionScript} $E{generateCompletionScript},
    where $E{generateCompletionScript} can be \(ShellType.orCases("one of")). If specified,
    a corresponding completion script is printed to standard output.
    """
