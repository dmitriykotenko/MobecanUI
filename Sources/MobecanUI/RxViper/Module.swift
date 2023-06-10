// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// Один из экранов приложения.
public protocol Module {

  /// Вью-контроллер с содержимым экрана.
  var viewController: UIViewController { get }

  /// Сигнал о том, что экран закончил свою работу и может быть закрыт.
  var finished: Observable<Void> { get }

  /// Демонстратор, чтобы открывать дополнительные модули из данного модуля.
  var demonstrator: Demonstrator? { get set }
}


public extension Module {

  /// Сигнал о том, что экран закончил свою работу и может быть закрыт.
  var finishedAsSingle: Single<Void> { finished.take(1).asSingle() }
}
