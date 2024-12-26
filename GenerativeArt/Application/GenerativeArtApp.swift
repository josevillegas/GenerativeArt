import SwiftUI

@main
struct GenerativeArtApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  static private let defaultDrawingType: DrawingType = .tile(.triangles)

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State private var selectedDrawingType: DrawingType? = Self.defaultDrawingType
  @State private var tiledDrawingType = TiledDrawingTypeWrapper(type: .triangles)
  @State private var mondrianDrawing = MondrianDrawing()
  @State private var foregroundColor: Color = .red
  @State private var backgroundColor: Color = .white
  @State private var tileSize: CGFloat = 0.5 // A value from zero to one.
  @State private var splitViewVisibility: NavigationSplitViewVisibility = .all

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingType: drawingType, tiledDrawingType: $tiledDrawingType, mondrianDrawing: $mondrianDrawing,
                        foregroundColor: $foregroundColor, backgroundColor: $backgroundColor, tileSize: $tileSize,
                        splitViewVisibility: $splitViewVisibility)
            .modifier(NavigationBarModifier())
          }
      }
    } else {
      NavigationSplitView(columnVisibility: $splitViewVisibility) {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationTitle("Generative Art")
          .toolbar(removing: .sidebarToggle)
      } detail: {
        DrawingView(drawingType: selectedDrawingType ?? Self.defaultDrawingType, tiledDrawingType: $tiledDrawingType,
                    mondrianDrawing: $mondrianDrawing, foregroundColor: $foregroundColor, backgroundColor: $backgroundColor,
                    tileSize: $tileSize, splitViewVisibility: $splitViewVisibility)
        .modifier(NavigationBarModifier())
      }
      .navigationSplitViewStyle(.prominentDetail)
    }
  }
}

struct NavigationBarModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 18, *) {
      content
        .toolbarVisibility(.hidden, for: .navigationBar)
    } else {
      content
        .navigationBarHidden(true)
    }
  }
}
