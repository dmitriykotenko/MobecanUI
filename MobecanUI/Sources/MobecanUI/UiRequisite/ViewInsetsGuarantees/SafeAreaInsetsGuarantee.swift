//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public protocol SafeAreaInsetsGuarantee {
  
  func guaranteedSafeAreaInsets(for view: UIView) -> OptionalEdgeInsets
}
