// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension Character: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    .pure {
      .random(
        fromString:
        """
        
        abcdefghijklmnopqrstuvwxyz\
        ABCDEFGHIJKLMNOPQRSTUVWXYZ\
        абвгдеёжзийклмнопрстуфхцчшщъыьэюя\
        АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ
        0123456789\
        .,;:?!-–—_\
        \\|/\
        '"«»„“\
        +=\
        @#$%^&*№\
        ()[]{}<>\
        🕵🏽‍♀️😛📡🇺🇳⚠️
        """
      )
    }
  }
}
