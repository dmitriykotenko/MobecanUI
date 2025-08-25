// Copyright © 2021 Mobecan. All rights reserved.


/// Версия ``Void``, 
/// которая поддерживает протоколы ``Equatable``, ``Hashable`` и ``Codable``
/// и к которой можно писать экстеншены для любого другого протокола.
public enum EquatableVoid: Int, Equatable, Hashable, Codable {

  case instance
}


public typealias EVoid = EquatableVoid
