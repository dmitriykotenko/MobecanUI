//  Copyright © 2020 Mobecan. All rights reserved.


public enum Loadable<Value, SomeError: Error> {
  
  case isLoading
  case loaded(Result<Value, SomeError>)
}


extension Loadable: Equatable where Value: Equatable, SomeError: Equatable {}
extension Loadable: Hashable where Value: Hashable, SomeError: Hashable {}
