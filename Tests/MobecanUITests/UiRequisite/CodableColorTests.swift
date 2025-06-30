// Copyright © 2025 Mobecan. All rights reserved.

import XCTest

import LayoutKit
import RxSwift
import RxTest
import UIKit

@testable import MobecanUI


class CodableColorTests: XCTestCase {

  func testSimpleColorSpaceConversions() {
    assertEqual(
      actual: .grayscale(white: 1).asDisplayP3color,
      expected: .displayP3(red: 1, green: 1, blue: 1, alpha: 1)
    )

    assertEqual(
      actual:
        .grayscale(white: 1)
          .withBrightnessMultiplied(by: 0)
          .asDisplayP3color,
      expected:
        .displayP3(red: 0, green: 0, blue: 0, alpha: 1),
      threshold: 0.01
    )
  }

  func testIdentityColorSpaceConversion() {
    let colors: [CodableColor] = [
      .grayscale(white: 0).asDisplayP3color,
      .grayscale(white: 0.1).asDisplayP3color,
      .grayscale(white: 0.25).asDisplayP3color,
      .grayscale(white: 0.5).asDisplayP3color,
      .grayscale(white: 0.75).asDisplayP3color,
      .grayscale(white: 0.9).asDisplayP3color,
      .grayscale(white: 1).asDisplayP3color,

        .rgb(red: 0, green: 0, blue: 0, alpha: 1).asDisplayP3color,
      .rgb(red: 1, green: 1, blue: 1, alpha: 1).asDisplayP3color,
      .rgb(red: 1, green: 0, blue: 0, alpha: 1).asDisplayP3color,
      .rgb(red: 0, green: 1, blue: 0, alpha: 1).asDisplayP3color,
      .rgb(red: 0, green: 0, blue: 1, alpha: 1).asDisplayP3color,
      .rgb(red: 1, green: 1, blue: 0, alpha: 1).asDisplayP3color,
      .rgb(red: 1, green: 0, blue: 1, alpha: 1).asDisplayP3color,
      .rgb(red: 0, green: 1, blue: 1, alpha: 1).asDisplayP3color,
      .rgb(red: 0.05, green: 0.7, blue: 0.11, alpha: 1).asDisplayP3color,
      .rgb(red: 0.98, green: 0.2, blue: 0.9, alpha: 1).asDisplayP3color,
      .rgb(red: 0, green: 1, blue: 0.34, alpha: 1).asDisplayP3color,

      .displayP3(red: 0, green: 0, blue: 0, alpha: 1),
      .displayP3(red: 1, green: 1, blue: 1, alpha: 1),
      .displayP3(red: 1, green: 0, blue: 0, alpha: 1),
      .displayP3(red: 0, green: 1, blue: 0, alpha: 1),
      .displayP3(red: 0, green: 0, blue: 1, alpha: 1),
      .displayP3(red: 1, green: 1, blue: 0, alpha: 1),
      .displayP3(red: 1, green: 0, blue: 1, alpha: 1),
      .displayP3(red: 0, green: 1, blue: 1, alpha: 1),
      .displayP3(red: 0.01, green: 0.02, blue: 0.005, alpha: 1),
      .displayP3(red: 0.91, green: 0.99, blue: 0.966, alpha: 1),
      .displayP3(red: 0.05, green: 0.7, blue: 0.11, alpha: 1),
      .displayP3(red: 0.98, green: 0.2, blue: 0.9, alpha: 1),
      .displayP3(red: 0, green: 1, blue: 0.34, alpha: 1),
    ]

    let transforms: [(CodableColor) -> CodableColor] = [
      { $0.withAlphaComponent(0).withAlphaComponent(1) },
      { $0.withAlphaMultiplied(by: 0.5).withAlphaComponent(1) },
      { $0.withAlphaMultiplied(by: 0).withAlphaComponent(1) },
      { .displayP3($0.displayP3.linearized.gammaCorrected) },
      { .displayP3($0.displayP3.xyz.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.okLch.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.okLch.okLab.displayP3) },
    ]

    for color in colors {
      for (transformIndex, transform) in transforms.enumerated() {
        checkThatColorDoesntChange(
          color: color,
          identityTransform: transform,
          transformIndex: transformIndex,
          threshold: 0.001
        )
      }
    }
  }

  func testThatAlphaIsPreservedDuringColorSpaceConversion() {
    let opaqueColors: [CodableColor] = [
      .grayscale(white: 0),
      .grayscale(white: 0.1),
      .grayscale(white: 0.5),
      .grayscale(white: 1),

      .rgb(red: 0, green: 0, blue: 0),
      .rgb(red: 1, green: 1, blue: 1),
      .rgb(red: 1, green: 0, blue: 0),
      .rgb(red: 0, green: 0, blue: 1),
      .rgb(red: 1, green: 1, blue: 0),
      .rgb(red: 0.05, green: 0.7, blue: 0.11),
      .rgb(red: 0, green: 1, blue: 0.34),

      .displayP3(red: 0, green: 0, blue: 0),
      .displayP3(red: 1, green: 1, blue: 1),
      .displayP3(red: 1, green: 0, blue: 0),
      .displayP3(red: 0, green: 1, blue: 0),
      .displayP3(red: 0.05, green: 0.7, blue: 0.11)
    ]

    let colors = opaqueColors.map {
      $0.withAlphaComponent(CGFloat.random(in: 0...1))
    }

    let transforms: [(CodableColor) -> CodableColor] = [
      { .displayP3($0.displayP3.linearized.gammaCorrected) },
      { .displayP3($0.displayP3.xyz.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.okLch.displayP3) },
      { .displayP3($0.displayP3.xyz.okLab.okLch.okLab.displayP3) },
    ]

    for color in colors {
      for (transformIndex, transform) in transforms.enumerated() {
        XCTAssertEqual(
          color.alpha,
          transform(color).alpha,
          "Colors \(color) and \(transform(color)) have too different alphas; transformIndex == \(transformIndex)"
        )
      }
    }
  }

  func testDisplayP3toXyzConversion() {
    checkXyz(
      actual: CodableColor.DisplayP3(red: 0, green: 0, blue: 0).xyz,
      expected: .init(x: 0, y: 0, z: 0, alpha: 1),
      threshold: 0.001
    )

    checkXyz(
      actual: CodableColor.DisplayP3(red: 1, green: 1, blue: 1).xyz,
      expected: .init(x: 0.9505, y: 1, z: 1.0888, alpha: 1),
      threshold: 0.001
    )

    checkXyz(
      actual: CodableColor.DisplayP3(red: 1, green: 1, blue: 0).xyz,
      expected: .init(x: 0.7523, y: 0.9207, z: 0.0451, alpha: 1),
      threshold: 0.001
    )
  }

  func testDisplayP3toOkLchConversion() {
    checkOkLch(
      actual: CodableColor.DisplayP3(red: 0, green: 0, blue: 0).xyz.okLab.okLch,
      expected: .init(lightness: 0, chroma: 0, hue: 0, alpha: 1),
      threshold: 0.001
    )

    checkOkLch(
      actual: CodableColor.DisplayP3(red: 1, green: 1, blue: 1).xyz.okLab.okLch,
      expected: .init(lightness: 1, chroma: 0, hue: 260, alpha: 1),
      threshold: 0.05
    )

    checkOkLch(
      actual: CodableColor.DisplayP3(red: 1, green: 1, blue: 0).xyz.okLab.okLch,
      expected: .init(lightness: 0.9648, chroma: 0.245, hue: 110.23, alpha: 1),
      threshold: 0.05
    )

    checkOkLch(
      actual: CodableColor.DisplayP3(red: 0, green: 1, blue: 0).xyz.okLab.okLch,
      expected: .init(lightness: 0.8488, chroma: 0.368483, hue: 145.649, alpha: 1),
      threshold: 0.05
    )
  }

  private func checkThatColorDoesntChange(color: CodableColor,
                                          identityTransform: (CodableColor) -> CodableColor,
                                          transformIndex: Int,
                                          threshold: CGFloat = 1e-15,
                                          file: StaticString = #file,
                                          line: UInt = #line) {
    assertEqual(
      actual: identityTransform(color),
      expected: color,
      threshold: threshold,
      errorMessageSuffix: "; transformIndex = \(transformIndex)",
      file: file,
      line: line
    )
  }

  private func assertEqual(actual: CodableColor,
                           expected: CodableColor,
                           threshold: CGFloat = 1e-15,
                           errorMessageSuffix: String = "",
                           file: StaticString = #file,
                           line: UInt = #line) {
    if !areEqual(
      actual: actual.displayP3.xyz.asVector,
      actualAlpha: actual.alpha,
      expected: expected.displayP3.xyz.asVector,
      expectedAlpha: 1,
      threshold: threshold
    ) {
      XCTFail(
        "Colors \(actual) and \(expected) are too different\(errorMessageSuffix)",
        file: file,
        line: line
      )
    }
  }

  private func areEqual(actual: ColorComponents,
                        actualAlpha: CGFloat,
                        expected: ColorComponents,
                        expectedAlpha: CGFloat,
                        threshold: CGFloat) -> Bool {
    let deltas = (
      x: abs(actual.0 - expected.0),
      y: abs(actual.1 - expected.1),
      z: abs(actual.2 - expected.2),
      alpha: abs(actualAlpha - expectedAlpha)
    )

    return deltas.x <= threshold
        && deltas.y <= threshold
        && deltas.z <= threshold
        && deltas.alpha <= threshold
  }

  private func checkXyz(actual: CodableColor.XYZ,
                        expected: CodableColor.XYZ,
                        threshold: CGFloat,
                        file: StaticString = #file,
                        line: UInt = #line) {
    if !areEqual(
      actual: actual.asVector,
      actualAlpha: actual.alpha,
      expected: expected.asVector,
      expectedAlpha: expected.alpha,
      threshold: threshold
    ) {
      XCTFail(
        "XYZ \(actual) and XYZ \(expected) are too different",
        file: file,
        line: line
      )
    }
  }

  private func checkOkLab(actual: CodableColor.OkLab,
                          expected: CodableColor.OkLab,
                          threshold: CGFloat,
                          file: StaticString = #file,
                          line: UInt = #line) {
    if !areEqual(
      actual: (actual.lightness, actual.a, actual.b),
      actualAlpha: actual.alpha,
      expected: (expected.lightness, expected.a, expected.b),
      expectedAlpha: expected.alpha,
      threshold: threshold
    ) {
      XCTFail(
        "OKLab \(actual) and OKLab \(expected) are too different",
        file: file,
        line: line
      )
    }
  }

  private func checkOkLch(actual: CodableColor.OkLch,
                          expected: CodableColor.OkLch,
                          threshold: CGFloat,
                          file: StaticString = #file,
                          line: UInt = #line) {
    if !areEqual(
      actual: (actual.lightness, actual.chroma, actual.hue),
      actualAlpha: actual.alpha,
      expected: (expected.lightness, expected.chroma, expected.hue),
      expectedAlpha: expected.alpha,
      threshold: threshold
    ) {
      XCTFail(
        "OKLCH \(actual) and OKLCH \(expected) are too different",
        file: file,
        line: line
      )
    }
  }
}
