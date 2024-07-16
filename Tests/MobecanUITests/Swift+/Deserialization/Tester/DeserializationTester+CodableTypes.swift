// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension DeserializationTester {

  @DerivesCodingKeysReflector
  struct WebSite: Equatable, Hashable, Codable {
    var homePage: URL

    enum CodingKeys: String, CodingKey {
      case homePage = "home_page"
    }
  }

  @DerivesCodingKeysReflector
  struct DataContainer: Equatable, Hashable, Codable {
    var someData: Data
  }

  @DerivesCodingKeysReflector
  struct Country: Equatable, Hashable, Codable {
    var name: String?
    var capital: CityEnum
  }

  @DerivesCodingKeysReflector
  enum CityEnum: String, Equatable, Hashable, Codable {
    case melbourne
    case pretoria
    case buenosAires
  }

  @DerivesCodingKeysReflector
  struct NumbersPhile: Equatable, Hashable, Codable {
    var favoriteNumber: GoodNumbersEnum
  }

  @DerivesCodingKeysReflector
  enum GoodNumbersEnum: Int, Equatable, Hashable, Codable {
    case zero = 0
    case minusTwo = -2
    case sixHundredsSixtySix = 666
  }

  @DerivesCodingKeysReflector
  struct Match: Equatable, Hashable, Codable {
    var players: [Player]
    var winner: Player?
    var score: Score
  }

  @DerivesCodingKeysReflector
  struct Score: Equatable, Hashable, Codable {
    
    @DerivesCodingKeysReflector
    struct SetScore: Equatable, Hashable, Codable {
      var winnerGames: Int
      var loserGames: Int
    }

    var sets: [SetScore]
  }

  @DerivesCodingKeysReflector
  struct Player: Equatable, Hashable, Codable {
    
    @DerivesCodingKeysReflector
    enum Hand: String, Codable { case right, left }

    @DerivesCodingKeysReflector
    struct Name: Equatable, Hashable, Codable {
      var firstName: String
      var lastName: String
    }

    var id: Int
    var height: Double?
    var name: Name
    var mainHand: Hand
  }
}
