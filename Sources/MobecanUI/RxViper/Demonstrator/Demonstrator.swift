// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


/// Используется, когда модуль хочет временно показать какой-то другой модуль.
public protocol Demonstrator {
  
  func demonstrate(module: Module) -> Single<Void>
  func demonstrate(module: Module, animating: Bool?) -> Single<Void>
}
