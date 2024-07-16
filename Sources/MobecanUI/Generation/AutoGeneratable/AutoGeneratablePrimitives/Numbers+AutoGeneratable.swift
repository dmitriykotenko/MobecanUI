// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension Int8: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension UInt8: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Int16: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension UInt16: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Int32: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension UInt32: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Int64: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension UInt64: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Int: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension UInt: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Float: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Double: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Self.random } }
}


extension Decimal: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    Double.defaultGenerator.map { Decimal($0) }
  }
}
