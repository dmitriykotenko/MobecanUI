// Copyright © 2021 Mobecan. All rights reserved.

import WebKit


public extension WKWebView {

  /// Removes all local data from the web view:
  /// cookies, caches, local storages, WebSQL databases etc.
  func resetLocalData(onComplete: @escaping () -> Void) {
    let dataStore = configuration.websiteDataStore

    dataStore.removeData(
      ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
      modifiedSince: .distantPast,
      completionHandler: onComplete
    )
  }
}
