// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Parameter builders & short decls

@resultBuilder
public struct qparams {

  public static func buildBlock(_ parts: [FunctionParameterSyntax]...) -> [FunctionParameterSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  public static func buildExpression(_ e: FunctionParameterSyntax) -> [FunctionParameterSyntax] {
    [e]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  public static func buildOptional(_ c: [FunctionParameterSyntax]?) -> [FunctionParameterSyntax] { c ?? [] }
  public static func buildEither(first c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }
  public static func buildEither(second c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }

  public static func buildArray(_ chunks: [[FunctionParameterSyntax]]) -> [FunctionParameterSyntax] {
    chunks.flatMap { $0 }
  }

  // availability branches
  public static func buildLimitedAvailability(_ c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }
}


public func qparamsList(@qparams _ make: () -> [FunctionParameterSyntax]) -> FunctionParameterListSyntax {
  let list = make()

  return FunctionParameterListSyntax(
    list.enumerated().map { index, parameter in
      parameter.with(
        \.trailingComma,
        index < list.count - 1 ? .commaToken(trailingTrivia: .space) : nil
      )
    }
  )
}


extension q {

  /// `name: type` with optional default
  public static func funcParam(_ name: String,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
    funcParam(q.tok.id(name), type, default: def)
  }

  /// `name: type` with optional default
  public static func funcParam(_ name: TokenSyntax,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
    FunctionParameterSyntax(
      firstName: name,
      colon: .colonToken(),
      type: type,
      defaultValue: def
    )
  }

  /// `name: type` with optional name and default
  public static func enumParam(_ name: String? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
    enumParam(
      name.map { q.tok.id($0) },
      type,
      default: def
    )
  }

  /// `name: type` with optional name and default
  public static func enumParam(_ name: TokenSyntax? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
    EnumCaseParameterSyntax(
      firstName: name,
      colon: .colonToken(),
      type: type,
      defaultValue: def
    )
  }

  /// Initializer with params & body
  public static func `init`(_ params: FunctionParameterListSyntax,
                            @qstmts _ body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
    InitializerDeclSyntax(
      initKeyword: .keyword(.`init`),
      signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: params)),
      body: qbody(body)
    )
  }

  /// Convenience overload: array of params
  public static func `init`(_ params: [FunctionParameterSyntax],
                            @qstmts _ body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
    `init`(
      FunctionParameterListSyntax(
        params.enumerated().map { index, param in
          param.with(
            \.trailingComma,
            index < params.count - 1 ? .commaToken(trailingTrivia: .space) : nil
          )
        }
      ),
      body
    )
  }
}



/// `name: type` with optional default
@inlinable public func _funcParam(_ name: String,
                             _ type: TypeSyntax,
                             default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
  q.funcParam(name, type, default: def)
}

/// `name: type` with optional default
@inlinable public func _funcParam(_ name: TokenSyntax,
                             _ type: TypeSyntax,
                             default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
  q.funcParam(name, type, default: def)
}

/// `name: type` with optional name and default
@inlinable public func _enumParam(_ name: String? = nil,
                             _ type: TypeSyntax,
                             default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
  q.enumParam(name, type, default: def)
}

/// `name: type` with optional name and default
@inlinable public func _enumParam(_ name: TokenSyntax? = nil,
                             _ type: TypeSyntax,
                             default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
  q.enumParam(name, type, default: def)
}
