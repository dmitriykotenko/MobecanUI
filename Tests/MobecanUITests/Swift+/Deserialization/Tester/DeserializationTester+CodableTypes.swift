// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension DeserializationTester {

  struct WebSite: Equatable, Hashable, Codable {
    var homePage: URL
  }

  struct DataContainer: Equatable, Hashable, Codable {
    var someData: Data
  }

  struct Country: Equatable, Hashable, Codable {
    var name: String?
    var capital: CityEnum
  }

  enum CityEnum: String, Equatable, Hashable, Codable {
    case melbourne
    case pretoria
    case buenosAires
  }

  struct NumbersPhile: Equatable, Hashable, Codable {
    var favoriteNumber: GoodNumbersEnum
  }

  enum GoodNumbersEnum: Int, Equatable, Hashable, Codable {
    case zero = 0
    case minusTwo = -2
    case sixHundredsSixtySix = 666
  }

  struct Match: Equatable, Hashable, Codable {
    var players: [Player]
    var winner: Player?
    var score: Score
  }

  struct Score: Equatable, Hashable, Codable {
    
    struct SetScore: Equatable, Hashable, Codable {
      var winnerGames: Int
      var loserGames: Int
    }

    var sets: [SetScore]
  }

  struct Player: Equatable, Hashable, Codable {
    
    enum Hand: String, Codable { case right, left }

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
