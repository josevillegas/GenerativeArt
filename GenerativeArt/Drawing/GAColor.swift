import UIKit

enum GAColor {
  case black
  case blue
  case green
  case lightGray
  case red
  case orange
  case purple
  case white
  case yellow
  case selection

  func color() -> UIColor {
    switch self {
    case .black: .black
    case .blue: .blue
    case .green: .green
    case .lightGray: GAColor.color(white: 0.9)
    case .red: .red
    case .orange: .orange
    case .purple: .purple
    case .white: .white
    case .yellow: .yellow
    case .selection: GAColor.color(red: 51, green: 204, blue: 255)
    }
  }

  static func color(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }

  static func color(white: CGFloat) -> UIColor {
    UIColor(white: white, alpha: 1)
  }
}
