import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType

  var body: some View {
    switch drawingType {
    case .paintingStyle(.mondrian): MondrianViewRepresentable()
    case let .tile(type): TiledDrawingViewRepresentable(type: type)
    }
  }
}

struct TiledDrawingViewRepresentable: UIViewControllerRepresentable {
  let type: TiledDrawingType

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    TiledDrawingViewController(viewModel: TiledDrawingViewModel(type: type), presentationMode: .secondary) { _ in }
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct MondrianViewRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    MondrianViewController(presentationMode: .secondary) { _ in }
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
