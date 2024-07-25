// Copyright © 2020 Mobecan. All rights reserved.

import NonEmpty
import RxSwift


@DerivesAutoGeneratable
@TryInit
public struct Location: Equatable, Hashable, Codable, Lensable {

  public var latitude: Double
  public var longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  public static var artilleryMuseum = Location(
    latitude: 59.954060,
    longitude: 30.313575
  )
  
  public static var moscowRailwayStation = Location(
    latitude: 59.929891,
    longitude: 30.362187
  )
  
  public static var imaxSapphire = Location(
    latitude: 59.981446,
    longitude: 30.210505
  )
  
  public static var peterPaulFortress = Location(
    latitude: 59.950074,
    longitude: 30.316414
  )
}
