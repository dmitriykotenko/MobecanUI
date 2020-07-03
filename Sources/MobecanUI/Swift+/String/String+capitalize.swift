//  Copyright © 2020 Mobecan. All rights reserved.


public extension String {

  var startWithCapitalLetter: String {
    prefix(1).capitalized + dropFirst()
  }
}
