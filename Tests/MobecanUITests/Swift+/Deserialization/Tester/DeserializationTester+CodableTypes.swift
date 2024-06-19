// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension DeserializationTester {

  @CodingKeysReflection
  struct WebSite: Equatable, Hashable, Codable {
    var homePage: URL

    enum CodingKeys: String, CodingKey {
      case homePage = "home_page"
    }
  }

  @CodingKeysReflection
  struct DataContainer: Equatable, Hashable, Codable {
    var someData: Data
  }

  @CodingKeysReflection
  struct Country: Equatable, Hashable, Codable {
    var name: String?
    var capital: CityEnum
  }

  @CodingKeysReflection
  enum CityEnum: String, Equatable, Hashable, Codable {
    case melbourne
    case pretoria
    case buenosAires
  }

  @CodingKeysReflection
  struct NumbersPhile: Equatable, Hashable, Codable {
    var favoriteNumber: GoodNumbersEnum
  }

  @CodingKeysReflection
  enum GoodNumbersEnum: Int, Equatable, Hashable, Codable {
    case zero = 0
    case minusTwo = -2
    case sixHundredsSixtySix = 666
  }

  @CodingKeysReflection
  struct Match: Equatable, Hashable, Codable {
    var players: [Player]
    var winner: Player?
    var score: Score
  }

  @CodingKeysReflection
  struct Score: Equatable, Hashable, Codable {
    
    @CodingKeysReflection
    struct SetScore: Equatable, Hashable, Codable {
      var winnerGames: Int
      var loserGames: Int
    }

    var sets: [SetScore]
  }

  @CodingKeysReflection
  struct Player: Equatable, Hashable, Codable {
    
    @CodingKeysReflection
    enum Hand: String, Codable { case right, left }

    @CodingKeysReflection
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
