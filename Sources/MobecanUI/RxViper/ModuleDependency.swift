//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public enum ModuleDependency {
  
  struct Output<OutputValue> {
    
    var module: Module
    var output: Observable<OutputValue>
    
    init<SomeModule: Module>(_ module: SomeModule,
                             output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.output = module[keyPath: output]
    }
  }
  
  struct OneTime<OutputValue> {
    
    var module: Module
    var output: Single<OutputValue>
    
    init<SomeModule: Module>(_ module: SomeModule,
                             output: KeyPath<SomeModule, Single<OutputValue>>) {
      self.module = module
      self.output = module[keyPath: output]
    }
  }
  
  struct Pipe<InputValue, OutputValue> {
    
    var module: Module
    var input: AnyObserver<InputValue>
    var output: Observable<OutputValue>
    
    init<SomeModule: Module>(_ module: SomeModule,
                             input: KeyPath<SomeModule, AnyObserver<InputValue>>,
                             output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.input = module[keyPath: input]
      self.output = module[keyPath: output]
    }
  }
  
  struct SmallPipe<InputValue, OutputValue> {
    
    var module: SmallModule
    var input: AnyObserver<InputValue>
    var output: Observable<OutputValue>
    
    init<SomeModule: SmallModule>(_ module: SomeModule,
                                  input: KeyPath<SomeModule, AnyObserver<InputValue>>,
                                  output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.input = module[keyPath: input]
      self.output = module[keyPath: output]
    }
  }
}


extension Module {
  
  func and<OutputValue>(output: KeyPath<Self, Observable<OutputValue>>) -> ModuleDependency.Output<OutputValue> {
    .init(self, output: output)
  }
  
  func and<OutputValue>(singleOutput: KeyPath<Self, Single<OutputValue>>) -> ModuleDependency.OneTime<OutputValue> {
    .init(self, output: singleOutput)
  }
  
  func and<Input, Output>(input: KeyPath<Self, AnyObserver<Input>>,
                          output: KeyPath<Self, Observable<Output>>) -> ModuleDependency.Pipe<Input, Output> {
    .init(self, input: input, output: output)
  }
}


extension SmallModule {
  
  func and<Input, Output>(input: KeyPath<Self, AnyObserver<Input>>,
                          output: KeyPath<Self, Observable<Output>>) -> ModuleDependency.SmallPipe<Input, Output> {
    .init(self, input: input, output: output)
  }
}
