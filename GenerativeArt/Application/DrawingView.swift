import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType

  @State var mondrianDrawing = MondrianDrawing()

  var body: some View {
    Group {
      switch drawingType {
      case .paintingStyle(.mondrian): MondrianViewRepresentable(drawing: $mondrianDrawing)
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
        Button(action: { next() }) { Image(systemName: "goforward") }
        Spacer()
      }
    }
  }

  private func next() {
    switch drawingType {
    case .tile: break
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  let type: TiledDrawingType

  func makeUIView(context: Context) -> UIView {
    TiledDrawingView(viewModel: TiledDrawingViewModel(type: type)) { _ in }
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MondrianViewRepresentable: UIViewRepresentable {
  @Binding var drawing: MondrianDrawing

  func makeUIView(context: Context) -> MondrianView {
    MondrianView(drawing: drawing)
  }

  func updateUIView(_ uiView: MondrianView, context: Context) {
    uiView.drawing = drawing
  }
}
