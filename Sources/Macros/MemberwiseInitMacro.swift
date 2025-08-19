// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Добавляет дефолтный конструктор,
/// заполняющий все поля класса или структуры и имеющий такую же видимость,
/// как и сам класс или сама структура.
public struct MemberwiseInitMacro {}


extension MemberwiseInitMacro: MemberMacro, MobecanDeclaration {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    return logMacroPerformance("MemberwiseInitMacro.expansion") {
      let initializer = declaration
        .macroGeneratedMemberwiseInitializer?
        .buildAsNonCompact

      return initializer.asSequence
    }
  }
}
