import SwiftUI

struct DetailView: UIViewControllerRepresentable {
  let drawingType: DrawingType
  let send: (Message) -> Void

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    switch drawingType {
    case .paintingStyle(.mondrian):
      MondrianViewController(presentationMode: .secondary, send: send)
    case let .tile(type):
      TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type), presentationMode: .secondary, send: send)
    }
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
