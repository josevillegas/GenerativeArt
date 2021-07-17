import UIKit
import Algorithms

extension Array where Element == UIBarButtonItem {
  func addingFlexibleSpaces() -> [UIBarButtonItem] {
    Array(self.interspersed(with: .flexibleSpace()))
  }
}
