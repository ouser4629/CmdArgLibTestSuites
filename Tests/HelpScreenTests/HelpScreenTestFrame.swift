//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeFrame
import CmdArgLibHelpScreen
import CmdArgLibCompletions

typealias Name = String
enum Pet: String, CmdArgEnum { case dog, cat, bird }

struct PersonS: CommandNodeFrame {
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var weight: Double?? = nil
    var sonHas: Variadic<Pet> = []
    var daughterHas: [Pet] = []
    var name: Name? = nil
    var generateCompletionScript: MetaOption<CompletionGenerator> = MetaOption(generator)

    // Configuration
    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "person-s",
        shadowGroups: ["u l"],
        embellishments: [
            .embellish("help", label: "h__help"),
            .embellish("name", label: "_", typeName: "Name?"),
            .embellish("count", label: "c__count"),
            .embellish("weight", label: "w__weigth"),
            .embellish("sonHas", label: "s__sonHas", typeName: "Variadic<Pet>"),
            .embellish("daughterHas", label: "d__daughterHas"),
            .embellish("generateCompletionScript", typeName: "MetaOption<Shell>"),
        ],
    )

    func run(state: [Void]) -> [Void]
    {
        var lines: [String] = []
        if let weight, let weight { lines.append("  \(name!) weighs \(weight) kgs.") }
        if !sonHas.isEmpty  { lines.append("  \(name!)'s son has \(sonHas.map{"a \($0)"}.joinedWith("and")).") }
        if !daughterHas.isEmpty  { lines.append("  \(name!)'s daughter has \(daughterHas.map{"a \($0)"}.joinedWith("and")).") }
        if lines.isEmpty  { lines.append("  No data was found for \(name!).") }
        if count < 0 { lines.reverse() }
        lines.insert("DATA:", at: 0)
        var line = lines.joined(separator: "\n")
        line = u ? line.uppercased() : l ? line.lowercased() : line
        for _ in 0..<abs(count) { print(line) }
        return []
    }

    private static let generator = CompletionGenerator(name: "person-s", suggestionElements: helpLayout)
}


private let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Collect and print a person's personal information."),
    .synopsis("\nUSAGE\n", line: ["!generateCompletionScript"]),
    .text("\nOPTIONS"),
    .parameter("help", "Show help information."),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("count", countDescription),
    .text("\nPERSONAL INFORMATION"),
    .parameter("weight", "The person's weight in kgs"),
    .parameter("sonHas", "One or more of the pets owned by the person's son", .list(Pet.cases)),
    .parameter("daughterHas", "A pet owned by the person's daughter (can be repeated)", .list(Pet.cases)),
    .parameter("name", "The person's name"),
    .text("\nPETS"),
    .pseudoParameter("bird","A bird is colorful, intelligent, vibrant and highly social"),
    .pseudoParameter("cat","A cat is agile, curious and cuddly"),
    .pseudoParameter("dog", "A dog is man's best friend"),
    .text("\nNOTES\n", note)
]

private let countDescription = """
    Print the output n times where n is the absolute value of the $T{count} passed
    to $J{count}. If the $T{count} is negative the data is listed in reverse order.
    """

private let note = """
    The $J{u} and $J{l} flags shadow each other; the last 
    one encountered determines the formatting.
    
    There is a hidden meta-option, "$J{generateCompletionScript} $E{generateCompletionScript}",
    where $E{generateCompletionScript} can be \(ShellType.orCases("one of")). If specified,
    a corresponding completion script is printed to standard output.
    """
