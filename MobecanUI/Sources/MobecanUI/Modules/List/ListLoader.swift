//  Copyright © 2020 Mobecan. All rights reserved.


public enum Loadable<Value, SomeError: Error> {
  
  case isLoading
  case loaded(Result<Value, SomeError>)
}
