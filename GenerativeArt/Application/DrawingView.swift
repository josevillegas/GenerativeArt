import SwiftUI

struct DrawingViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct DrawingView: View {
  let drawingType: DrawingType
  @Binding var tiledDrawingType: TiledDrawingTypeWrapper
  @Binding var mondrianDrawing: MondrianDrawing
  @Binding var foregroundColor: Color
  @Binding var backgroundColor: Color
  @Binding var tileSize: CGFloat

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
  }
}
