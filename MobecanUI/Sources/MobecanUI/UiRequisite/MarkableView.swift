//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// View which can modify its labels according to given text
/// (e. g., it can mark occurrences of the text by special background color).
public protocol MarkableView: UIView {
  
  var textToMark: AnyObserver<String?> { get }
}
