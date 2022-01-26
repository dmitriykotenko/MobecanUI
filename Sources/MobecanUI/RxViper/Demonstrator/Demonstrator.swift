// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


/// Used when some Module wants to temporarily show another Module.
public protocol Demonstrator {
  
  func demonstrate(module: Module) -> Single<Void>
  func demonstrate(module: Module, animating: Bool?) -> Single<Void>
}
