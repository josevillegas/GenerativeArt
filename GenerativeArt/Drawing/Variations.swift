import Foundation

enum Variation2 {
  case a
  case b

  static func random() -> Variation2 {
    switch Int.random(in: 1...2) {
    case 1: .a
    default: .b
    }
  }
}

enum Variation4 {
  case a
  case b
  case c
  case d

  static func random() -> Variation4 {
    switch Int.random(in: 1...4) {
    case 1: .a
    case 2: .b
    case 3: .c
    default: .d
    }
  }
}
