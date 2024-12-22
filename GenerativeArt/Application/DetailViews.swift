import SwiftUI

struct TiledDrawingViewRepresentable: UIViewControllerRepresentable {
  let type: TiledDrawingType
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type), presentationMode: .secondary, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct MondrianViewRepresentable: UIViewControllerRepresentable {
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    MondrianViewController(presentationMode: .secondary, send: send)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
