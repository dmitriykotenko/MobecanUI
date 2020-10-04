//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func joined(start: Element? = nil,
              separator: Element? = nil,
              end: Element? = nil) -> [Element] {
    joined(start: start, separator: { separator }, end: end)
  }

  func joined(start: Element? = nil,
              separator: () -> Element? = { nil },
              end: Element? = nil) -> [Element] {
    
    let allButLast = dropLast().flatMap { [$0] + separator().asSequence }
    
    return start.asSequence + allButLast + last.asSequence + end.asSequence
  }
}
