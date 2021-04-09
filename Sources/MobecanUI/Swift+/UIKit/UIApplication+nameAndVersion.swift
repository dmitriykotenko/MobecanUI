//  Copyright © 2021 Mobecan. All rights reserved.

import UIKit


// Few methods for getting application's name and version.
// Implementation is stolen from https://stackoverflow.com/a/60363400/2350528 .
public extension UIApplication {

  var name: String {
    infoPlistValue(key: "CFBundleName") ?? "Unknown app name"
  }

  var version: String {
    infoPlistValue(key: "CFBundleShortVersionString") ?? "Unknown app version"
  }

  var buildNumber: String {
    infoPlistValue(key: "CFBundleVersion") ?? "(Unknown build number"
  }

  var minimumOsVersion: String {
    infoPlistValue(key: "MinimumOSVersion") ?? "Unknown minimum OSVersion"
  }

  var bundleIdentifier: String {
    infoPlistValue(key: "CFBundleIdentifier") ?? "Unknown bundle identifier"
  }

  private func infoPlistValue(key: String) -> String? {
    infoPlistDictionary?[key] as? String
  }

  private var infoPlistDictionary: [String: Any]? { Bundle.main.infoDictionary }
}
