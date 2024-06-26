// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  enum StopOrContinue<T> {
    case stop(T)
    case next(T)
  }
  
  func foldWhile<T>(_ initialValue: T,
                    _ process: (T, Element) -> StopOrContinue<T>) -> T {
    var result = initialValue
    var index = 0
    var shouldContinue = isNotEmpty
    
    while shouldContinue {
      let nextElement = process(result, self[index])
      
      switch nextElement {
      case .stop(let finalResult):
        result = finalResult
        shouldContinue = false
      case .next(let nextResult):
        result = nextResult
        index += 1
      }
      
      if index >= count { shouldContinue = false }
    }
    
    return result
  }

  func foldWhileFromRight<T>(_ initialValue: T,
                             _ process: (Element, T) -> StopOrContinue<T>) -> T {
    reversed()
      .foldWhile(initialValue, { process($1, $0) })
  }

  func splitWhile(_ predicate: ([Element], Element) -> Bool) -> ([Element], [Element]) {
    let margin = foldWhile(0, { index, _ in
      if predicate(Array(prefix(index)), self[index]) {
        return .next(index + 1)
      } else {
        return .stop(index)
      }
    })
    
    return (Array(prefix(margin)), Array(dropFirst(margin)))
  }

  func splitWhileFromRight(_ predicate: (Element, [Element]) -> Bool) -> ([Element], [Element]) {
    let margin = foldWhileFromRight(count, { _, index in
      if predicate(self[index - 1], Array(suffix(count - index))) {
        return .next(index - 1)
      } else {
        return .stop(index)
      }
    })

    return (Array(prefix(margin)), Array(dropFirst(margin)))
  }
}
