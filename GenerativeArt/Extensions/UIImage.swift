import UIKit

extension UIImage {
  static var backChevron: UIImage { image(withName: "chevron.backward") }
  static var goForward: UIImage { image(withName: "goforward") }
  static var pause: UIImage { image(withName: "pause") }
  static var play: UIImage { image(withName: "play") }

  private static func image(withName name: String) -> UIImage {
    UIImage(systemName: name) ?? .empty
  }

  private static var empty: UIImage { UIImage() }
}
