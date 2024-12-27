import SwiftUI

struct DrawingView: View {
  let drawingID: UUID
  let drawingType: DrawingType
  let tiledDrawingType: TiledDrawingType
  let mondrianDrawing: MondrianDrawing
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat

  @State private var tiledDrawing = TiledDrawing()
  @State private var tileSizeControl: TileSizeControl = .empty
  @State private var viewSize: CGSize = .zero
  @State private var unitSize: CGFloat = 30

  private let scale = UIScreen.main.scale

  var body: some View {
    GeometryReader { proxy in
      Group {
        switch drawingType {
        case .paintingStyle(.mondrian):
          DrawingCanvas(paths: mondrianDrawing.paths(frame: CGRect(origin: .zero, size: viewSize)))
            .padding(24)
            .background(Color(white: 0.9), ignoresSafeAreaEdges: Edge.Set())

        case .tile:
          DrawingCanvas(paths: tiledDrawing.paths)
            .frame(width: tiledDrawing.tiles.size.width, height: tiledDrawing.tiles.size.height)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .preference(key: DrawingViewSizePreferenceKey.self, value: proxy.size)
    }
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { newSize in viewSize = newSize }
    .onChange(of: drawingID) { _, _ in updateTiledDrawing() }
    .onChange(of: tiledDrawingType) { _, _ in updateTiledDrawing() }
    .onChange(of: foregroundColor) { _, _ in updateTiledDrawing() }
    .onChange(of: backgroundColor) { _, _ in updateTiledDrawing() }
    .onChange(of: tileSize) { _, _ in
      unitSize = tileSizeControl.widthForValue(tileSize)
      updateTiledDrawing()
    }
    .onChange(of: viewSize) { _, _ in
      tileSizeControl = TileSizeControl(boundsSize: viewSize, minWidth: 20)
      unitSize = tileSizeControl.widthForValue(tileSize)
      updateTiledDrawing()
    }
  }

  private func updateTiledDrawing() {
    tiledDrawing = TiledDrawing(type: tiledDrawingType, tiles: tiles)
    tiledDrawing.foregroundColor = foregroundColor
    tiledDrawing.backgroundColor = backgroundColor
    tiledDrawing.updateVariations()
  }

  private var tiles: Tiles {
    Tiles(maxSize: viewSize, maxTileSize: unitSize, scale: scale)
  }
}

struct DrawingViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}
