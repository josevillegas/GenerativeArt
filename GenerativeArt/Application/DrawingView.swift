import SwiftUI

struct DrawingView: View {
  let drawingID: UUID
  let drawingType: DrawingType
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat

  @State private var viewSize: CGSize = .zero
  @State private var unitSize: CGFloat = 30

  var body: some View {
    GeometryReader { proxy in
      DrawingInternalView(drawingID: drawingID, drawingType: drawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                          viewSize: viewSize, unitSize: unitSize)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .preference(key: DrawingViewSizePreferenceKey.self, value: proxy.size)
    }
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { newSize in viewSize = newSize }
    .onChange(of: tileSize) { _, _ in updateUnitSize() }
    .onChange(of: viewSize) { _, _ in updateUnitSize() }
  }

  private func updateUnitSize() {
    unitSize = TileSizeControl.widthForValue(tileSize, viewSize: viewSize)
  }
}

struct DrawingViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

/// We need an extra layer so that a new view isn't generated every time tileSize changes.
struct DrawingInternalView: View {
  let drawingID: UUID
  let drawingType: DrawingType
  let foregroundColor: Color
  let backgroundColor: Color
  let viewSize: CGSize
  let unitSize: CGFloat

  private let scale = UIScreen.main.scale

  var body: some View {
    switch drawingType {
    case let .tile(type): TiledDrawingCanvas(tiledDrawing: tiledDrawing(type: type), backgroundColor: backgroundColor)
    case .paintingStyle(.mondrian):
      DrawingCanvas(paths: MondrianDrawing().paths(size: viewSize), backgroundColor: .white)
        .padding(24)
        .background(Color(white: 0.9), ignoresSafeAreaEdges: Edge.Set())
    }
  }

  private func tiledDrawing(type: TiledDrawingType) -> TiledDrawing {
    var tiledDrawing = TiledDrawing(type: type, tiles: tiles)
    tiledDrawing.foregroundColor = foregroundColor
    tiledDrawing.backgroundColor = backgroundColor
    tiledDrawing.updateVariations()
    return tiledDrawing
  }

  private var tiles: Tiles {
    Tiles(maxSize: viewSize, maxTileSize: unitSize, scale: scale)
  }
}
