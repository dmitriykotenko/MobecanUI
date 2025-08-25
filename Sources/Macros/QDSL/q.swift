// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Root namespace: q

public enum q {

  // MARK: tokens
  public enum tok {
    public static let `self` = TokenSyntax.keyword(.self)
    public static let `init` = TokenSyntax.keyword(.`init`)
    public static func id(_ s: String) -> TokenSyntax { .identifier(s) }
    public static func keyword(_ keyword: Keyword) -> TokenSyntax { .keyword(keyword) }
  }

  // MARK: types
  public enum t {

    public static func id(_ s: String) -> TypeSyntax {
      id(tok.id(s))
    }

    public static func id(_ token: TokenSyntax) -> TypeSyntax {
      TypeSyntax(IdentifierTypeSyntax(name: token))
    }

    public static func generic(_ base: String,
                               _ args: [TypeSyntax]) -> TypeSyntax {
      generic(tok.id(base), args)
    }

    public static func generic(_ base: TokenSyntax,
                               _ args: [TypeSyntax]) -> TypeSyntax {
      TypeSyntax(
        IdentifierTypeSyntax(
          name: base,
          genericArgumentClause: args.isEmpty ? nil : GenericArgumentClauseSyntax(
            arguments: GenericArgumentListSyntax(
              args.enumerated().map { index, argument in
                GenericArgumentSyntax(
                  argument: .type(argument),
                  trailingComma: index < args.count - 1 ? .commaToken(trailingTrivia: .space) : nil
                )
              }
            )
          )
        )
      )
    }

    public static func optional(_ wrapped: TypeSyntax) -> TypeSyntax {
      TypeSyntax(OptionalTypeSyntax(wrappedType: wrapped))
    }

    public static func array(_ element: some TypeSyntaxProtocol) -> TypeSyntax {
      TypeSyntax(ArrayTypeSyntax(element: element))
    }

    public static func dictionary(_ key: some TypeSyntaxProtocol,
                                  _ value: some TypeSyntaxProtocol) -> TypeSyntax {
      TypeSyntax(DictionaryTypeSyntax(key: key, value: value))
    }

    public static func result(_ wrapped: TypeSyntax,
                              _ error: TypeSyntax) -> TypeSyntax {
      generic("Result", [wrapped, error])
    }
  }

  // MARK: exprs
  public enum e {

    public static func forceTry(_ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: .exclamationMarkToken(),
        expression: throwingExpr
      ))
    }

    public static func optionalTry(_ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: .postfixQuestionMarkToken(),
        expression: throwingExpr
      ))
    }

    public static func `try`(questionOrExclamationMark: TokenSyntax? = nil,
                             _ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: questionOrExclamationMark,
        expression: throwingExpr
      ))
    }

    public static func forceUnwrap(_ expr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(ForceUnwrapExprSyntax(expression: expr))
    }

    public static func ref(_ name: TokenSyntax) -> ExprSyntax {
      ExprSyntax(DeclReferenceExprSyntax(baseName: name))
    }

    public static func ref(_ name: String) -> ExprSyntax {
      ref(tok.id(name))
    }

    public static func bool(_ bool: Bool) -> ExprSyntax {
      ExprSyntax(BooleanLiteralExprSyntax(literal: .keyword(bool ? .true : .false)))
    }

    public static func int(_ int: Int) -> ExprSyntax {
      ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral(String(int))))
    }

    public static func string(_ string: String) -> ExprSyntax {
      ExprSyntax(
        StringLiteralExprSyntax(content: string)
      )
    }

    public static func emptyDictionaryLiteral() -> ExprSyntax {
      ExprSyntax(
        DictionaryExprSyntax(content: .colon(.colonToken()))
      )
    }

    public static func dictionaryLiteral(
      @qdictionary_elements _ content: () -> [DictionaryElementSyntax]
    ) -> ExprSyntax {
      ExprSyntax(
        DictionaryExprSyntax(content: .elements(.init(content())))
      )
    }

    /// Converts a TypeSyntax into an expression (for constructor calls).
    public static func type(_ ty: TypeSyntax) -> ExprSyntax {
      ExprSyntax(TypeExprSyntax(type: ty))
    }

    /// self.member
    public static func self_dot(_ name: TokenSyntax) -> ExprSyntax {
#if swift(>=5.10)
      return ExprSyntax(
        MemberAccessExprSyntax(
          base: DeclReferenceExprSyntax(baseName: tok.`self`),
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: name)
        )
      )
#else
      return ExprSyntax(
        MemberAccessExprSyntax(
          base: ExprSyntax(DeclReferenceExprSyntax(baseName: tok.`self`)),
          dot: .periodToken(),
          name: name
        )
      )
#endif
    }

    /// self.member
    public static func self_dot(_ name: String) -> ExprSyntax {
      self_dot(tok.id(name))
    }

    /// .member
    public static func dot(_ name: String) -> ExprSyntax {
      dot(tok.id(name))
    }

    /// .member
    public static func dot(_ name: TokenSyntax) -> ExprSyntax {
#if swift(>=5.10)
      return ExprSyntax(
        MemberAccessExprSyntax(
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: name)
        )
      )
#else
      return ExprSyntax(
        MemberAccessExprSyntax(base: nil, dot: .periodToken(), name: name)
      )
#endif
    }

    /// lhs = rhs
    public static func assign(_ left: ExprSyntax,
                              _ right: ExprSyntax) -> ExprSyntax {
      ExprSyntax(
        SequenceExprSyntax {
          left
          ExprSyntax(AssignmentExprSyntax(
            leadingTrivia: .space,
            equal: .equalToken(),
            trailingTrivia: .space
          ))
          right
        }
      )
    }

    /// self.x = x
    public static func assignSelf(_ name: String) -> ExprSyntax { assign(self_dot(name), ref(name)) }
  }
}


public let _nil = ExprSyntax(NilLiteralExprSyntax())


@inlinable public func _bool(_ bool: Bool) -> ExprSyntax {
  q.e.bool(bool)
}


@inlinable public func _int(_ int: Int) -> ExprSyntax {
  q.e.int(int)
}

@inlinable public func _string(_ string: String) -> ExprSyntax {
  q.e.string(string)
}


extension TypeSyntax {

  public func _t(_ name: String,
                 genericArgs: [TypeSyntax] = []) -> TypeSyntax {
    _t(
      q.tok.id(name),
      genericArgs: genericArgs
    )
  }

  public func _t(_ token: TokenSyntax,
                 genericArgs: [TypeSyntax] = []) -> TypeSyntax {
    TypeSyntax(MemberTypeSyntax(
      baseType: self,
      name: token,
      genericArgumentClause: genericArgs.isEmpty ? nil : GenericArgumentClauseSyntax(
        arguments: GenericArgumentListSyntax(
          genericArgs.enumerated().map { index, argument in
            GenericArgumentSyntax(
              argument: .type(argument),
              trailingComma: genericArgs.trailingComma(forIndex: index)
            )
          }
        )
      )
    ))
  }
}


public extension q {

  /// `.success(expr)`
  static func success(_ e: ExprSyntax) -> ExprSyntax {
    q.e.dot("success").call(e)
  }

  /// Wrap parameter in `Result<Wrapped, ErrorType>` and default to `.success(oldDefault)`
  static func wrapParamInResult(_ p: FunctionParameterSyntax,
                                error: String = "SomeError") -> FunctionParameterSyntax {
    p
      .with(
        \.type,
         _t(_result: p.type.withoutEscapingIfNecessary, _t(error))
      )
      .with(
        \.defaultValue,
         p.defaultValue.map { ^=success($0.value) }
      )
  }
}


//public typealias _e = q.e


/// `.success(expr)`
@inlinable public func _success(_ e: ExprSyntax) -> ExprSyntax {
  _dot("success").call(e)
}


@inlinable public func _ref(_ s: String) -> ExprSyntax { q.e.ref(s) }
@inlinable public func _ref(_ s: TokenSyntax) -> ExprSyntax { q.e.ref(s) }

@inlinable public func _dot(_ s: String) -> ExprSyntax { q.e.dot(s) }
@inlinable public func _dot(_ s: TokenSyntax) -> ExprSyntax { q.e.dot(s) }

@inlinable public func _self_dot(_ name: TokenSyntax) -> ExprSyntax { q.e.self_dot(name) }
@inlinable public func _self_dot(_ name: String) -> ExprSyntax { q.e.self_dot(name) }

@inlinable public func _namedType(_ name: String) -> ExprSyntax {
  q.e.type(q.t.id(name))
}

@inlinable public func _t(_ base: String,
                          _ args: [TypeSyntax] = []) -> TypeSyntax {
  q.t.generic(base, args)
}

@inlinable public func _t(_ base: TokenSyntax,
                          _ args: [TypeSyntax] = []) -> TypeSyntax {
  q.t.generic(base, args)
}

@inlinable public func _t(_array element: TypeSyntax) -> TypeSyntax {
  q.t.array(element)
}

@inlinable public func _t(_dictionary key: TypeSyntax,
                          _ value: TypeSyntax) -> TypeSyntax {
  q.t.dictionary(key, value)
}

@inlinable public func _t(_result success: TypeSyntax,
                          _ failure: TypeSyntax) -> TypeSyntax {
  q.t.result(success, failure)
}

public let _emptyDictionaryLiteral: ExprSyntax = q.e.emptyDictionaryLiteral()

@inlinable public func _dictionaryLiteral(
  @qdictionary_elements _ content: () -> [DictionaryElementSyntax]
) -> ExprSyntax {
  q.e.dictionaryLiteral(content)
}

//
//  @inlinable public static func optional(_ wrapped: TypeSyntax) -> TypeSyntax {
//    TypeSyntax(OptionalTypeSyntax(wrappedType: wrapped))
//  }
//
//  @inlinable public static subscript(_ element: some TypeSyntaxProtocol) -> TypeSyntax {
//    TypeSyntax(ArrayTypeSyntax(element: element))
//  }
//
//  @inlinable public static subscript(_ key: some TypeSyntaxProtocol,
//                                     _ value: some TypeSyntaxProtocol) -> TypeSyntax {
//    TypeSyntax(DictionaryTypeSyntax(key: key, value: value))
//  }
//
//  @inlinable public static func Result(_ wrapped: TypeSyntax,
//                                       _ error: TypeSyntax) -> TypeSyntax {
//    q.t.generic("Result", [wrapped, error])
//  }


extension TypeSyntax {

  var opt: TypeSyntax {
    q.t.optional(self)
  }

  func optIf(_ condition: Bool) -> TypeSyntax {
    condition ? opt : self
  }
}


/// Function with generics/where (body builder).
@inlinable public func _func(_ name: String,
                             modifiers: DeclModifierListSyntax = [],
                             generics: GenericParameterClauseSyntax? = nil,
                             params: FunctionParameterListSyntax = qparamsList { },
                             returns: TypeSyntax? = nil,
                             whereClause: GenericWhereClauseSyntax? = nil,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
  _func(
    q.tok.id(name),
    modifiers: modifiers,
    generics: generics,
    params: params,
    returns: returns,
    whereClause: whereClause,
    body: body
  )
}

@inlinable public func _func(_ name: TokenSyntax,
                             modifiers: DeclModifierListSyntax = [],
                             generics: GenericParameterClauseSyntax? = nil,
                             params: FunctionParameterListSyntax = qparamsList { },
                             returns: TypeSyntax? = nil,
                             whereClause: GenericWhereClauseSyntax? = nil,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
  qdecl_ext.func(
    name,
    modifiers: modifiers,
    generics: generics,
    params: params,
    returns: returns,
    whereClause: whereClause,
    body: body
  )
}

/// Initializer with generics/where (body builder).
@inlinable public func _init(modifiers: DeclModifierListSyntax = [],
                             generics: GenericParameterClauseSyntax? = nil,
                             params: FunctionParameterListSyntax,
                             whereClause: GenericWhereClauseSyntax? = nil,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
  qdecl_ext.`init`(
    modifiers: modifiers,
    params: params,
    generics: generics,
    whereClause: whereClause,
    body: body
  )
}


@inlinable public func _token(_ s: String) -> TokenSyntax { .identifier(s) }

public let _token_init: TokenSyntax = q.tok.`init`

public typealias k = Keyword



/// Converts a TypeSyntax into an expression (for constructor calls).
@inlinable public func _e(_ type: TypeSyntax) -> ExprSyntax {
  q.e.type(type)
}


extension FunctionParameterSyntax {

  /// Wrap parameter in `Result<Wrapped, ErrorType>` and default to `.success(oldDefault)`
  func asTryInitParameter(index: Int,
                          error: String = "SomeError") -> FunctionParameterSyntax {
    if isNamed {
      self
        .with(
          \.type,
          _t(_result: type.withoutEscapingIfNecessary, _t(error))
        )
        .with(
          \.defaultValue,
          defaultValue.map { ^=_success($0.value) }
        )
    } else {
      with(\.secondName, _token("_\(index)"))
    }
  }

}
