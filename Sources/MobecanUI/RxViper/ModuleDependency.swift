//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public enum ModuleDependency {
  
  public struct Output<OutputValue>: Lensable {
    
    public var module: Module
    public var output: Observable<OutputValue>
    
    public init<SomeModule: Module>(_ module: SomeModule,
                                    output: @escaping (SomeModule) -> Observable<OutputValue>) {
      self.module = module
      self.output = output(module)
    }

    public init<SomeModule: Module>(_ module: SomeModule,
                                    output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.output = module[keyPath: output]
    }
  }
  
  public struct OneTime<OutputValue>: Lensable {
    
    public var module: Module
    public var output: Single<OutputValue>

    public init<SomeModule: Module>(_ module: SomeModule,
                                    output: @escaping (SomeModule) -> Single<OutputValue>) {
      self.module = module
      self.output = output(module)
    }

    public init<SomeModule: Module>(_ module: SomeModule,
                                    output: KeyPath<SomeModule, Single<OutputValue>>) {
      self.module = module
      self.output = module[keyPath: output]
    }
  }
  
  public struct Pipe<InputValue, OutputValue>: Lensable {
    
    public var module: Module
    public var input: AnyObserver<InputValue>
    public var output: Observable<OutputValue>
    
    public init<SomeModule: Module>(_ module: SomeModule,
                                    input: @escaping (SomeModule) -> AnyObserver<InputValue>,
                                    output: @escaping (SomeModule) -> Observable<OutputValue>) {
      self.module = module
      self.input = input(module)
      self.output = output(module)
    }

    public init<SomeModule: Module>(_ module: SomeModule,
                                    input: KeyPath<SomeModule, AnyObserver<InputValue>>,
                                    output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.input = module[keyPath: input]
      self.output = module[keyPath: output]
    }
  }
  
  public struct MiniPipe<InputValue, OutputValue>: Lensable {
    
    public var module: MiniModule
    public var input: AnyObserver<InputValue>
    public var output: Observable<OutputValue>

    public init<SomeModule: MiniModule>(_ module: SomeModule,
                                        input: @escaping (SomeModule) -> AnyObserver<InputValue>,
                                        output: @escaping (SomeModule) -> Observable<OutputValue>) {
      self.module = module
      self.input = input(module)
      self.output = output(module)
    }

    public init<SomeModule: MiniModule>(_ module: SomeModule,
                                        input: KeyPath<SomeModule, AnyObserver<InputValue>>,
                                        output: KeyPath<SomeModule, Observable<OutputValue>>) {
      self.module = module
      self.input = module[keyPath: input]
      self.output = module[keyPath: output]
    }
  }
}


public extension Module {

  func and<OutputValue>(output: @escaping (Self) -> Observable<OutputValue>) -> ModuleDependency.Output<OutputValue> {
    .init(self, output: output)
  }

  func and<OutputValue>(output: KeyPath<Self, Observable<OutputValue>>) -> ModuleDependency.Output<OutputValue> {
    .init(self, output: output)
  }

  func and<OutputValue>(singleOutput: @escaping (Self) -> Single<OutputValue>)
  -> ModuleDependency.OneTime<OutputValue> {
    .init(self, output: singleOutput)
  }

  func and<OutputValue>(singleOutput: KeyPath<Self, Single<OutputValue>>) -> ModuleDependency.OneTime<OutputValue> {
    .init(self, output: singleOutput)
  }

  func and<Input, Output>(input: @escaping (Self) -> AnyObserver<Input>,
                          output: @escaping (Self) -> Observable<Output>) -> ModuleDependency.Pipe<Input, Output> {
    .init(self, input: input, output: output)
  }

  func and<Input, Output>(input: KeyPath<Self, AnyObserver<Input>>,
                          output: KeyPath<Self, Observable<Output>>) -> ModuleDependency.Pipe<Input, Output> {
    .init(self, input: input, output: output)
  }
}


public extension MiniModule {

  func and<Input, Output>(input: @escaping (Self) -> AnyObserver<Input>,
                          output: @escaping (Self) -> Observable<Output>) -> ModuleDependency.MiniPipe<Input, Output> {
    .init(self, input: input, output: output)
  }

  func and<Input, Output>(input: KeyPath<Self, AnyObserver<Input>>,
                          output: KeyPath<Self, Observable<Output>>) -> ModuleDependency.MiniPipe<Input, Output> {
    .init(self, input: input, output: output)
  }
}
