import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class ModuleDependencyTests: XCTestCase {}


class TinyModule: SmallModule {
  
  let initialValue = AnyObserver<Int> { _ in }
  let editingResult = Observable<String>.never()
  
  public let uiView = UIView()
}


class GiantModule: Module {
  
  public var finished: Observable<Void> = .never()
  
  let initialValue = AnyObserver<Int> { _ in }
  let editingResult = Observable<String>.never()
  
  public let viewController = UIViewController()
}


class AndOutputTester {
  var listModule: ListModule<Int, String, Double, Error> { fatalError() }
  
  init() {
    _ = ModuleDependency.Output(listModule, output: \.elementEvent)
    _ = listModule.and(output: \.elementEvent)
  }
}


class AndPipeTester {
  
  init() {
    let tinyModule = GiantModule()
    
    _ = ModuleDependency.Pipe(tinyModule, input: \.initialValue, output: \.editingResult)
    _ = tinyModule.and(input: \.initialValue, output: \.editingResult)
  }
}


class AndSingleOutputTester {
  
  var editorModule: EditorModule<Int, String, Error> { fatalError() }
  
  init() {
    _ = ModuleDependency.OneTime(editorModule, output: \.editingResult)
    _ = editorModule.and(singleOutput: \.editingResult)
  }
}


class SmallModuleAndPipeTester {
  
  init() {
    let tinyModule = TinyModule()
    
    _ = ModuleDependency.SmallPipe(tinyModule, input: \.initialValue, output: \.editingResult)
    _ = tinyModule.and(input: \.initialValue, output: \.editingResult)
  }
}
