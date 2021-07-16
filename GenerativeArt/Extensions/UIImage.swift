import UIKit

extension UIImage {
  static var backChevron: UIImage {
    UIImage(systemName: "chevron.backward") ?? .empty
  }

  static var empty: UIImage {
    UIImage()
  }
}
