// Copyright © 2024 Mobecan. All rights reserved.


extension String {

  func asCodeBlock(startDelimiter: String,
                   endDelimiter: String,
                   indentation: String = "  ") -> String {
    "{" + startDelimiter + indentation.prependingToLines(of: self) + endDelimiter + "}"
  }
}
