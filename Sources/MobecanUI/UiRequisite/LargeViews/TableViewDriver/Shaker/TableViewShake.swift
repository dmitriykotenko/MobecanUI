// Copyright © 2020 Mobecan. All rights reserved.


public enum TableViewShake: Equatable, Hashable {
 
  case reloadData
  case insertSection(at: Int) // swiftlint:disable:this identifier_name
  case reloadSection(Int)
  case deleteSection(Int)
  case insertRows(rows: [Int], section: Int)
  case reloadRows(rows: [Int], section: Int)
  case deleteRows(rows: [Int], section: Int)
}
