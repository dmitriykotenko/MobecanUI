// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MobecanUI",
  platforms: [.iOS(.v11)],
  products: [
    .library(
      name: "MobecanUI",
      targets: ["MobecanUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift", from: .init(5, 1, 1)),
    .package(url: "https://github.com/RxSwiftCommunity/RxOptional", from: .init(4, 1, 0)),
    .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: .init(3, 0, 3)),
    .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard", from: .init(1, 0, 0)),
    .package(url: "https://github.com/onevcat/Kingfisher", from: .init(5, 14, 0)),
    .package(url: "https://github.com/SnapKit/SnapKit", from: .init(5, 0, 1)),
    .package(url: "https://github.com/dmitriykotenko/SwiftDateTime", from: .init(0, 1, 2))
  ],
  targets: [
    .target(
      name: "MobecanUI",
      dependencies: [
        "RxSwift", "RxOptional", "RxGesture", "RxKeyboard",
        "SnapKit",
        "Kingfisher",
        "SwiftDateTime"
      ]
    ),
    .testTarget(
      name: "MobecanUITests",
      dependencies: ["MobecanUI", "RxTest", "RxBlocking"]
    )
  ]
)
