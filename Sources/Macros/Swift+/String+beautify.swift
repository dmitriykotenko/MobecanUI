// Copyright © 2024 Mobecan. All rights reserved.


extension String {

  func asSingleLineIfShort(lengthThreshold: Int = 100,
                           separator: String = " ") -> String {
    count <= lengthThreshold ?
      lines.map(\.trimmingBlanks).mkString(separator: separator) :
      self
  }

  var compactifiedIfShort: String {
    guard count <= 100, commaEndingLines.count <= 2, bracesLevelsCount <= 2
    else { return self }

    return withCompactifiedCommaSeparatedLines.withCompactifiedBraces
  }

  var withCompactifiedBraces: String {
    lines.reduce("") { result, line in
      (result.hasSuffix("(") || line.hasPrefix(")")) ?
        result + line.trimmingBlanks :
        result + .newLine + line
    }
  }

  var withCompactifiedCommaSeparatedLines: String {
    lines.reduce("") { result, line in
      result.hasSuffix(",") ?
        result + " " + line.trimmingBlanks :
        result + .newLine + line
    }
  }

  var commaEndingLines: [SubSequence] {
    lines.filter { $0.hasSuffix(",") }
  }

  var bracesLevelsCount: Int {
    bracesLevelsCount(maximal: 0, current: 0)
  }

  private func bracesLevelsCount(maximal: Int, 
                                 current: Int) -> Int {
    guard let firstBraceIndex = firstIndex(where: { $0 == "(" || $0 == ")" })
    else { return maximal }

    let shift = self[firstBraceIndex] == "(" ? 1 : -1

    let newCurrent = current + shift
    let newMax = max(maximal, newCurrent)

    return self[index(after: firstBraceIndex)...]
      .asString
      .bracesLevelsCount(maximal: newMax, current: newCurrent)
  }
}
