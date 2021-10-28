//  Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public struct Money: Equatable, Hashable, Codable, Lensable, CustomStringConvertible {

  public var amount: Decimal
  public var currency: Currency
  
  public var isZero: Bool { amount == 0 }

  public init(amount: Decimal,
              currency: Currency) {
    self.amount = amount
    self.currency = currency
  }

  public static func roubles(_ amount: Decimal) -> Money {
    Money(
      amount: amount,
      currency: .rouble
    )
  }
  
  public static func dollars(_ amount: Decimal) -> Money {
    Money(
      amount: amount,
      currency: .dollar
    )
  }
  
  public var description: String {
    switch currency {
    case .rouble:
      return "\(amount) " + [currency.symbol]
    case .dollar:
      return [currency.symbol] + " \(amount)"
    }
  }
}


public extension Int {

  var roubles: Money { .roubles(Decimal(self)) }
  var dollars: Money { .dollars(Decimal(self)) }
}


public extension Decimal {

  var roubles: Money { .roubles(self) }
  var dollars: Money { .dollars(self) }
}
