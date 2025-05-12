// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "MobecanUI",
  platforms: [.iOS(.v12), .macOS(.v12)],
  products: [
    .library(
      name: "MobecanUI",
      targets: ["MobecanUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/dmitriykotenko/swift-syntax", branch: "feature/swift6.1_ios12"),
    .package(url: "https://github.com/pointfreeco/swift-nonempty", .upToNextMajor(from: "0.4.0")),
    .package(url: "https://github.com/dmitriykotenko/swift-custom-dump", branch: "ios12xcode16"),
    .package(url: "https://github.com/ReactiveX/RxSwift", from: .init(6, 2, 0)),
    .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: .init(5, 0, 4)),
    .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: .init(4, 0, 2)),
    .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard", from: .init(2, 0, 0)),
    .package(url: "https://github.com/dmitriykotenko/Kingfisher", branch: "7.12xcode16"),
    .package(url: "https://github.com/SnapKit/SnapKit", from: .init(5, 7, 1)),
    .package(url: "https://github.com/dmitriykotenko/LayoutKit", branch: "feature/swift-5.3"),
    .package(url: "https://github.com/dmitriykotenko/SwiftDateTime", from: .init(0, 2, 2))
  ],
  targets: [
    .target(
      name: "MobecanUI",
      dependencies: [
        "MobecanUIMacros",
        .product(name: "NonEmpty", package: "swift-nonempty"),
        .product(name: "CustomDump", package: "swift-custom-dump"),
        "RxSwift", "RxOptional", "RxGesture", "RxKeyboard",
        "SnapKit",
        "LayoutKit",
        "Kingfisher",
        "SwiftDateTime"
      ]
    ),
    .macro(
      name: "MobecanUIMacros",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ],
      path: "Sources/Macros"
    ),
    .testTarget(
      name: "MobecanUITests",
      dependencies: [
        "MobecanUI",
        "MobecanUIMacros",
        .product(name: "NonEmpty", package: "swift-nonempty"),
        .product(name: "CustomDump", package: "swift-custom-dump"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
        "LayoutKit",
        .product(name: "RxTest", package: "RxSwift"),
        .product(name: "RxBlocking", package: "RxSwift")
      ]
    )
  ]
)
