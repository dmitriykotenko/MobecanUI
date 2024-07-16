// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import RxSwift


extension URL: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<URL> {
    .rxPure {
      let scheme = Bool.random() ? "https://" : "http://"

      let domainsCount = Int.random(in: 1...5)

      let domains = (0..<domainsCount).map { _ in
        String.random(
          count: .random(in: 1..<10), 
          charactersFrom: "abcdefghijklmnopqrstuvwxyz"
        )
      }

      let zone = NonEmptySet("com", "org", "ru", "yandex", "co.uk").randomElement()

      let urlString = scheme + (domains + [zone]).mkString(separator: ".")

      switch URL(string: urlString) {
      case let url?:
        return .just(.success(url))
      case nil:
        return .just(.failure(.init(message: "Can not init URL from string \(urlString.quoted)")))
      }
    }
  }
}
