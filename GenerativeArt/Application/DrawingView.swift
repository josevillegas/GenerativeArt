import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType

  var body: some View {
    Group {
      switch drawingType {
      case .paintingStyle(.mondrian): MondrianViewRepresentable()
      case let .tile(type): TiledDrawingViewRepresentable(type: type)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Spacer()
        Button("Front") {}
        Spacer()
        Button("Back") {}
        Spacer()
        Button("Size") {}
        Spacer()
        Button(action: {}) { Image(systemName: "play") }
        Spacer()
        Button(action: {}) { Image(systemName: "goforward") }
        Spacer()
      }
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
