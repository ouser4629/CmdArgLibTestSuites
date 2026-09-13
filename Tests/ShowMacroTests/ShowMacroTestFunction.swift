//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen

enum Color: String, CmdArgEnum { case red, blue, yellow }
enum Animal: String, CmdArgEnum { case cat, dog, cow }

typealias Greeting = String
typealias FullName = String
typealias File = String

@MainFunctionMacro
func showMacros(
    h_help_help help: MetaFlag = MetaFlag(helpElements: helpElements),
    callNamesMacro: MetaFlag = MetaFlag(string: callNamesNote),
    labelMacros: MetaFlag = MetaFlag(helpElements: [.lines("", labelsNote)]),
    typeMacros: MetaFlag = MetaFlag(helpElements: [.lines("", typesNote)]),
    g greeting: Greeting = "Hello",
    n__name maybeName: FullName?,
    c__color colors: [Color],
    a__animals animals: Variadic<Animal>) throws
{
    var line = ""
        let name = maybeName ?? "nil"
        let lines = ["greeting: \(greeting)", "maybeName: \(name)", "color: \(colors)", "animals: \(animals)"]
        line = lines.joined(separator: "\n")
    throw Exception.stdout(line)
}

private let helpElements: [ShowElement] = [
    .text("DESCRIPTION\n", "Print parsed values of command line arguments."),
    .synopsis("\nUSAGE\n"),
    .text("\nPARAMETERS"),
    .parameter("greeting", "The greeting to print"),
    .parameter("maybeName", "If specified, the name of the person to greet"),
    .parameter("colors", "Append $E{colors} to the array of colors (can be repeated)"),
    .parameter("animals", "One or more animals (if specified)"),
    .text("\nMETA-OPTIONS"),
    .parameter("help", "Show this help screen"),
    .parameter("callNamesMacro","Show call name show macro expansion"),
    .parameter("labelMacros","Show label show macro expansion"),
    .parameter("typeMacros","Show type and element show macro expansion"),
]

private let callNamesNote = #"The call name is "$N{}""#


private let labelsNote = """
    * the shortest label of the "greeting" parameter is "$S{greeting}"
    * the shortest label of the "maybeName" parameter is "$S{maybeName}"
    * the shortest label of the "color" parameter is "$S{colors}"
    * the longest label of the "greeting" parameter is "$L{greeting}"
    * the longest label of the "maybeName" parameter is "$L{maybeName}"
    * the longest label of the "color" parameter is "$L{colors}"
    * the joined labels of the "greeting" parameter is "$J{greeting}"
    * the joined labels of the "maybeName" parameter is "$J{maybeName}"
    * the joined labels of the "color" parameter is "$J{colors}"
    * the joined labels of the "help" parameter is "$J{help}"
    """

private let typesNote = """
  * the type of the "greeting" parameter is "$T{greeting}"
  * the type of the "name" parameter is "$T{maybeName}"
  * the type of the "colors" parameter is "$T{colors}"
  * the type of the "animals" parameter is "$T{animals}"
  * the type of the wrapped element of the "maybeName" parameter is "$E{maybeName}"
  * the type of an element of the "colors" parameter is "$E{colors}" 
  * the type of an element of the "animals" parameter is "$E{animals}"
  * the description of the element type of the "maybeName" parameter is "$D{maybeName}"
  """

