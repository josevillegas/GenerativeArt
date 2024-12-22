import UIKit

extension UIImage {
  static var backChevron: UIImage { image(withName: "chevron.backward") }
  static var goForward: UIImage { image(withName: "goforward") }
  static var pause: UIImage { image(withName: "pause") }
  static var play: UIImage { image(withName: "play") }
  static var sidebar: UIImage { image(withName: "sidebar.leading") }

  static func dismiss(with presentationMode: DrawingPresentationMode) -> UIImage {
    switch presentationMode {
    case .pushed: .backChevron
    case .secondary: .sidebar
    }
  }

  private static func image(withName name: String) -> UIImage {
    UIImage(systemName: name) ?? .empty
  }

  private static var empty: UIImage { UIImage() }
}
