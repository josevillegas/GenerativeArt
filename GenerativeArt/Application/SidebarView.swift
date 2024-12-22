import SwiftUI

struct SidebarView: UIViewControllerRepresentable {
  let sections: [IndexSection]
  let appearance: IndexAppearance
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    IndexViewController(sections: sections, appearance: appearance, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
