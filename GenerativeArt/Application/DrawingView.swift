import SwiftUI

struct DrawingView: View {
  let drawingID: UUID
  let drawingType: DrawingType
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat

  @State private var viewSize: CGSize = .zero
  @State private var unitSize: CGFloat = 30

  private let scale = UIScreen.main.scale

  var body: some View {
    GeometryReader { proxy in
      Group {
        switch drawingType {
        case let .tile(type): TiledDrawingCanvas(tiledDrawing: tiledDrawing(type: type), backgroundColor: backgroundColor)
        case .paintingStyle(.mondrian):
          DrawingCanvas(paths: MondrianDrawing().paths(size: viewSize), backgroundColor: .white)
            .padding(24)
            .background(Color(white: 0.9), ignoresSafeAreaEdges: Edge.Set())
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .preference(key: DrawingViewSizePreferenceKey.self, value: proxy.size)
    }
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { newSize in viewSize = newSize }
    .onChange(of: tileSize) { _, _ in updateUnitSize() }
    .onChange(of: viewSize) { _, _ in updateUnitSize() }
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
