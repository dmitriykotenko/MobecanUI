// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension String: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    .pure {
      .random(
        count: .random(in: 0...100),
        charactersFrom: """

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
