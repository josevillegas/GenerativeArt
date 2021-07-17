import UIKit
import Algorithms

extension Array where Element == UIBarButtonItem {
  func addingFlexibleSpaces() -> [UIBarButtonItem] {
    Array(self.interspersed(with: .flexibleSpace()))
  }
}

protocol BarButtonItemProvider {
  func barButtonItem(title: String, action: Selector) -> UIBarButtonItem
  func barButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem
}

extension BarButtonItemProvider {
  func barButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(title: title, style: .plain, target: self, action: action)
  }

  func barButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(image: image, style: .plain, target: self, action: action)
  }
}
