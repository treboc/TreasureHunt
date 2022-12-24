//
//  Optional+BoundString.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 24.12.22.
//

import Foundation

extension Optional where Wrapped == String {
  var _boundString: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }

  public var boundString: String {
    get {
      return _boundString ?? ""
    }
    set {
      _boundString = newValue.isEmpty ? nil : newValue
    }
  }
}
