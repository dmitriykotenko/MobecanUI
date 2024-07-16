// Copyright © 2024 Mobecan. All rights reserved.


extension Collection {

  var asAnonymousArguments: [String] {
    indices.map { index in "$\(index)" }
  }

  var asCaptureSet: String {
    mkString(start: "[", separator: ", ", end: "]")
  }
}
