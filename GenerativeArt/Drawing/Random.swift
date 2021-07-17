import UIKit

enum Random {
  static func point(in rect: CGRect) -> CGPoint {
    CGPoint(
      x: CGFloat.random(in: rect.origin.x...(rect.origin.x + rect.size.width)),
      y: CGFloat.random(in: rect.origin.y...(rect.origin.y + rect.size.height))
    )
  }
}
