// Copyright © 2020 Mobecan. All rights reserved.


public extension String {
  
  func containsCaseInsensitively(_ otherString: String) -> Bool {
    lowercased().contains(otherString.lowercased())
  }
}
