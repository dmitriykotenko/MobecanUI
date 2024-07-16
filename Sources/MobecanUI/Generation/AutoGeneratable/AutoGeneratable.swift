// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public protocol AutoGeneratable {

  associatedtype BuiltinGenerator: MobecanGenerator<Self>

  static var defaultGenerator: BuiltinGenerator { get }
}



/// Проверяет во время компляции, что `Value` реализует протокол ``AutoGeneratable``.
///
/// - Note: Тайпалиас нужен для более понятных сообщений об ошибках в макросе ``AutoGeneratableMacro``.
public typealias AsAutoGeneratable<Value: AutoGeneratable> = Value
