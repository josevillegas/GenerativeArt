import SwiftUI

struct DrawingNavigationView: View {
  @Binding var selectedDrawingType: DrawingType?
  @Binding var splitViewVisibility: NavigationSplitViewVisibility
  let tiledDrawingType: TiledDrawingTypeWrapper
  let mondrianDrawing: MondrianDrawing
  @Binding var foregroundColor: Color
  @Binding var  backgroundColor: Color
  @Binding var  tileSize: CGFloat
  let isPlaying: Bool
  let perform: (ToolbarAction) -> Void

  static let defaultDrawingType: DrawingType = .tile(.triangles)

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingType: drawingType, tiledDrawingType: tiledDrawingType, mondrianDrawing: mondrianDrawing,
                        foregroundColor: foregroundColor, backgroundColor: backgroundColor, tileSize: tileSize)
            .modifier(ToolbarModifier(type: drawingType, foregroundColor: $foregroundColor, backgroundColor: $backgroundColor,
                                      tileSize: $tileSize, isPlaying: isPlaying, perform: perform))
            .modifier(NavigationBarModifier())
          }
      }
    } else {
      NavigationSplitView(columnVisibility: $splitViewVisibility) {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationTitle("Generative Art")
          .toolbar(removing: .sidebarToggle)
      } detail: {
        DrawingView(drawingType: selectedDrawingType ?? Self.defaultDrawingType, tiledDrawingType: tiledDrawingType,
                    mondrianDrawing: mondrianDrawing, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                    tileSize: tileSize)
        .modifier(ToolbarModifier(type: selectedDrawingType ?? Self.defaultDrawingType, foregroundColor: $foregroundColor,
                                  backgroundColor: $backgroundColor, tileSize: $tileSize, isPlaying: isPlaying, perform: perform))
        .modifier(NavigationBarModifier())
      }
      .navigationSplitViewStyle(.prominentDetail)
    }
  }
}

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
