// Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public extension URLRequest {

  /// Returns a cURL command representation of this URL request.
  var asCurlString: String {
    guard let url = url else { return "" }
    
    let baseCommand = ["curl \"\(url.absoluteString)\""]

    let headCommand = httpMethod
      .filter { $0 == "HEAD" }
      .map { _ in " --head" }
      .asSequence

    let methodCommand = httpMethod
      .filter { $0 != "GET" && $0 != "HEAD" }
      .map { "-X \($0)" }
      .asSequence

    let headerCommands =
      (allHTTPHeaderFields ?? [:]).map { key, value in "-H '\(key): \(value)'" }

    let bodyCommand = httpBody
      .flatMap { String(data: $0, encoding: .utf8) }
      .map { "-d '\($0)'" }
      .asSequence

    return
      (baseCommand + headCommand + methodCommand + headerCommands + bodyCommand)
      .joined(separator: " ")
  }
}
