// Copyright © 2021 Mobecan. All rights reserved.


public enum SerializationError: Error {

  case canNotSerialize(nestedError: Error)
  case canNotDeserialize(nestedError: Error)
}
