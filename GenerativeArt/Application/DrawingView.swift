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

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingType

  typealias UIViewType = UIView

  func makeUIView(context: Context) -> UIView {
    TiledDrawingView(viewModel: TiledDrawingViewModel(type: type)) { _ in }
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MondrianViewRepresentable: UIViewRepresentable {
  typealias UIViewControllerType = UIView

  func makeUIView(context: Context) -> UIView {
    MondrianView()
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}
