import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
    self.init(red: convert(red), green: convert(green), blue: convert(blue), alpha: alpha)
  }
}

private func convert(_ value: Int) -> CGFloat {
  CGFloat(max(min(255, value), 0)) / 255
}
