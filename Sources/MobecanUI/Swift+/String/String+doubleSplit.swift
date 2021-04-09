//  Copyright © 2021 Mobecan. All rights reserved.


public extension String {

  func doubleSplit(outerSeparator: Character,
                   innerSeparator: Character) -> [[String]] {
    split(separator: outerSeparator).map {
      $0.split(separator: innerSeparator).map { $0.asString }
    }
  }
}
