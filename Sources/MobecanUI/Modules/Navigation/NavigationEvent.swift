// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public enum NavigationEvent: Equatable {
  
  case push(Module)
  case pop
  case popTo(Module.Type)

  public static func == (this: NavigationEvent, that: NavigationEvent) -> Bool {
    switch (this, that) {
    case (.push(let thisModule), .push(let thatModule)):
      return thisModule.viewController == thatModule.viewController
    case (.pop, .pop):
      return true
    case (.popTo(let thisModuleType), .popTo(let thatModuleType)):
      return thisModuleType == thatModuleType
    default:
      return false
    }
  }
}


public extension Observable where Element == NavigationEvent {
  
  var pushes: Observable<Module> {
    compactMap {
      switch $0 {
      case .push(let module):
        return module
      case .pop, .popTo:
        return nil
      }
    }
  }

  var pops: Observable<Void> {
    compactMap {
      switch $0 {
      case .push, .popTo:
        return nil
      case .pop:
        return ()
      }
    }
  }

  var popsTo: Observable<Module.Type> {
    compactMap {
      switch $0 {
      case .push, .pop:
        return nil
      case .popTo(let moduleType):
        return moduleType
      }
    }
  }
}
