import SwiftUI

struct DrawingView: View {
  let drawingType: DrawingType
  let tiledDrawingType: TiledDrawingTypeWrapper
  let mondrianDrawing: MondrianDrawing
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat

  @State var viewSize: CGSize = .zero

  var body: some View {
    GeometryReader { proxy in
      Group {
        switch drawingType {
        case .paintingStyle(.mondrian): MondrianView(drawing: mondrianDrawing)
        case .tile: TiledDrawingView(type: tiledDrawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                                     tileSize: tileSize, viewSize: proxy.size)
        }
      }
      .preference(key: DrawingViewSizePreferenceKey.self, value: proxy.size)
    }
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { newSize in viewSize = newSize }
  }
}

struct DrawingViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}
