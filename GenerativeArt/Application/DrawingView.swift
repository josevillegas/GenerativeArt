import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType

  @State var tiledDrawingType = TiledDrawingTypeWrapper(type: .triangles)
  @State var mondrianDrawing = MondrianDrawing()

  var body: some View {
    Group {
      switch drawingType {
      case .paintingStyle(.mondrian): MondrianViewRepresentable(drawing: $mondrianDrawing)
      case .tile: TiledDrawingViewRepresentable(type: $tiledDrawingType)
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
    .onChange(of: drawingType) { oldValue, newValue in
      switch drawingType {
      case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
      case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
      }
    }
  }

  private func next() {
    switch drawingType {
    case let .tile(type):
      tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }
}

struct TiledDrawingViewRepresentable: UIViewRepresentable {
  @Binding var type: TiledDrawingTypeWrapper

  func makeUIView(context: Context) -> TiledDrawingView {
    TiledDrawingView(type: type.type)
  }

  func updateUIView(_ view: TiledDrawingView, context: Context) {
    view.type = type.type
  }
}

struct MondrianViewRepresentable: UIViewRepresentable {
  @Binding var drawing: MondrianDrawing

  func makeUIView(context: Context) -> MondrianView {
    MondrianView(drawing: drawing)
  }

  func updateUIView(_ view: MondrianView, context: Context) {
    view.drawing = drawing
  }
}

// This is needed so that the UIViewRepresentable registers changes.
struct TiledDrawingTypeWrapper: Equatable {
  let id = UUID()
  let type: TiledDrawingType
}
