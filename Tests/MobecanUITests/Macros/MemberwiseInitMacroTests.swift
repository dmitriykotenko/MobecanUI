// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


final class MemberwiseInitMacroTests: MacrosTester {

  func testPerformance1() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      measure {
        for _ in 1...100 {
          checkThat(
            code: """
            @MemberwiseInit
            open class Triple {
            
              public var first: String = ""
              private var second: Int
              let third: Double
            }
            """,
            expandsTo: """
            open class Triple {
            
              public var first: String = ""
              private var second: Int
              let third: Double
            
              public init(
                first: String = "",
                second: Int,
                third: Double
              ) {
                self.first = first
                self.second = second
                self.third = third
              }
            }
            """
          )
        }
      }
    }
  }

  func testEmptyStruct() {
    checkThat(
      code: "@MemberwiseInit struct Empty {}",
      expandsTo: """
      struct Empty {

        init(

        ) {
        }
      }
      """
    )
  }

  func testEmptyClass() {
    checkThat(
      code: "@MemberwiseInit class Empty {}",
      expandsTo: """
      class Empty {

        init(

        ) {
        }
      }
      """
    )
  }

  func testPublicEmptyClass() {
    checkThat(
      code: "@MemberwiseInit public class Empty {}",
      expandsTo: """
      public class Empty {

        public init(

        ) {
        }
      }
      """
    )
  }

  func testOpenEmptyClass() {
    checkThat(
      code: "@MemberwiseInit open class Empty {}",
      expandsTo: """
      open class Empty {

        public init(

        ) {
        }
      }
      """
    )
  }

  func testSimplePrivateStruct() {
    checkThat(
      code: """
      @MemberwiseInit
      private struct Pair {

        var first: String
        var second: Int
      }
      """,
      expandsTo: """
      private struct Pair {

        var first: String
        var second: Int

        init(
          first: String,
          second: Int
        ) {
          self.first = first
          self.second = second
        }
      }
      """
    )
  }

  func testStoredPropertiesWithDefaultValues() {
    checkThat(
      code: """
      @MemberwiseInit
      open class Triple {

        public var first: String = ""
        private var second: Int
        let third: Double
      }
      """,
      expandsTo: """
      open class Triple {

        public var first: String = ""
        private var second: Int
        let third: Double

        public init(
          first: String = "",
          second: Int,
          third: Double
        ) {
          self.first = first
          self.second = second
          self.third = third
        }
      }
      """
    )
  }

  func testClassWithClosuresAmongStoredProperties() {
    checkThat(
      code: """
      @MemberwiseInit
      open class Triple {

        public var first: (Bool) -> Bool = { !$0 }
        private var second: ((Int, Int), String) -> () -> Int
        private var third: ((Bool) -> Bool)?
      }
      """,
      expandsTo: """
      open class Triple {

        public var first: (Bool) -> Bool = { !$0 }
        private var second: ((Int, Int), String) -> () -> Int
        private var third: ((Bool) -> Bool)?

        public init(
          first: @escaping (Bool) -> Bool = {
            !$0
          },
          second: @escaping ((Int, Int), String) -> () -> Int,
          third: ((Bool) -> Bool)? = nil
        ) {
          self.first = first
          self.second = second
          self.third = third
        }
      }
      """
    )
  }
}
