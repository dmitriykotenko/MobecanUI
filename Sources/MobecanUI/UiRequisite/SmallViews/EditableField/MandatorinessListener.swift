// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public protocol MandatorinessListener {

  var isMandatory: AnyObserver<Bool> { get }
}
