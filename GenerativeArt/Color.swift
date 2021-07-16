import UIKit

enum Color {
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
    case .black: return .black
    case .blue: return .blue
    case .green: return .green
    case .lightGray: return Color.color(white: 0.9)
    case .red: return .red
    case .orange: return .orange
    case .purple: return .purple
    case .white: return .white
    case .yellow: return .yellow
    case .selection: return Color.color(red: 51, green: 204, blue: 255)
    }
  }

  static func color(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }

  static func color(white: CGFloat) -> UIColor {
    UIColor(white: white, alpha: 1)
  }
}
