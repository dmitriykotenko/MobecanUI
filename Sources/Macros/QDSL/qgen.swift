// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Generics & where clauses (functions/inits)

extension q {
  
  public enum gen {

    public static func params(_ names: [String]) -> GenericParameterClauseSyntax {
      GenericParameterClauseSyntax(
        parameters: GenericParameterListSyntax(
          names.enumerated().map { i, n in
            GenericParameterSyntax(
              name: q.tok.id(n),
              trailingComma: i < names.count - 1 ? .commaToken(trailingTrivia: .space) : nil
            )
          }
        )
      )
    }

    public static func params(_ params: [GenericParameterSyntax]) -> GenericParameterClauseSyntax {
      GenericParameterClauseSyntax(
        parameters: GenericParameterListSyntax(
          params.enumerated().map { index, param in
            param.with(
              \.trailingComma, index == params.count - 1 ? nil : .commaToken()
            )
          }
        )
      )
    }

    public static func param(_ name: String,
                             inherits: TypeSyntax? = nil) -> GenericParameterSyntax {
      param(q.tok.id(name), inherits: inherits)
    }

    public static func param(_ name: TokenSyntax,
                             inherits: TypeSyntax? = nil) -> GenericParameterSyntax {
      GenericParameterSyntax(
        name: name,
        colon: inherits == nil ? nil : .colonToken(trailingTrivia: .space),
        inheritedType: inherits
      )
    }

    public static func whereClause(_ reqs: [GenericRequirementSyntax.Requirement]) -> GenericWhereClauseSyntax {
      GenericWhereClauseSyntax(
        whereKeyword: .keyword(.where),
        requirements: GenericRequirementListSyntax(
          reqs.enumerated().map { index, req in
            GenericRequirementSyntax(
              requirement: req,
              trailingComma: index < reqs.count - 1 ? .commaToken(trailingTrivia: .space) : nil
            )
          }
        )
      )
    }

    public static func sameType(_ left: TypeSyntax,
                                _ right: TypeSyntax) -> GenericRequirementSyntax.Requirement {
      .sameTypeRequirement(
        SameTypeRequirementSyntax(
          leftType: .type(left),
          equal: .spacedBinaryOperator("=="),
          rightType: .type(right)
        )
      )
    }

    public static func conformance(_ someType: TypeSyntax,
                                   _ someProtocol: TypeSyntax) -> GenericRequirementSyntax.Requirement {
      .conformanceRequirement(
        ConformanceRequirementSyntax(
          leftType: someType,
          colon: .colonToken(trailingTrivia: .space),
          rightType: someProtocol
        )
      )
    }
  }
}

public enum qdecl_ext {
  
  /// Function with generics/where (body builder).
  public static func `func`(_ name: String,
                            modifiers: DeclModifierListSyntax = [],
                            generics: GenericParameterClauseSyntax? = nil,
                            params: FunctionParameterListSyntax = _funcParams { },
                            returns: TypeSyntax? = nil,
                            whereClause: GenericWhereClauseSyntax? = nil,
                            @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
    self.func(
      q.tok.id(name),
      modifiers: modifiers,
      generics: generics,
      params: params,
      returns: returns,
      whereClause: whereClause,
      body: body
    )
  }

  /// Function with generics/where (body builder).
  public static func `func`(_ name: TokenSyntax,
                            modifiers: DeclModifierListSyntax = [],
                            generics: GenericParameterClauseSyntax? = nil,
                            params: FunctionParameterListSyntax = _funcParams { },
                            returns: TypeSyntax? = nil,
                            whereClause: GenericWhereClauseSyntax? = nil,
                            @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
    FunctionDeclSyntax(
      modifiers: modifiers,
      funcKeyword: .keyword(.func),
      name: name,
      genericParameterClause: generics,
      signature: FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: params),
        returnClause: returns.map {
          ReturnClauseSyntax(
            arrow: .arrowToken(trailingTrivia: .space),
            type: $0
          )
        }
      ),
      genericWhereClause: whereClause,
      body: qbody(body)
    )
  }

  /// Initializer with generics/where (body builder).
  public static func `init`(modifiers: DeclModifierListSyntax = [],
                            params: FunctionParameterListSyntax,
                            generics: GenericParameterClauseSyntax? = nil,
                            whereClause: GenericWhereClauseSyntax? = nil,
                            @qstmts body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
    InitializerDeclSyntax(
      modifiers: modifiers,
      initKeyword: .keyword(.`init`),
      genericParameterClause: generics,
      signature: FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: params)
      ),
      genericWhereClause: whereClause,
      body: qbody(body)
    )
  }
}


extension TokenSyntax {


  public static func spacedBinaryOperator(
    _ text: String,
    presence: SourcePresence = .present
  ) -> TokenSyntax {
    return TokenSyntax(
      .binaryOperator(text),
      leadingTrivia: [.spaces(1)],
      trailingTrivia: [.spaces(1)],
      presence: presence
    )
  }

}


public typealias _gen = q.gen
