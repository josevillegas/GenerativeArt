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

  @State private var isPlaying: Bool = false

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingType: drawingType, tiledDrawingType: $tiledDrawingType, mondrianDrawing: $mondrianDrawing,
                        foregroundColor: $foregroundColor, backgroundColor: $backgroundColor, tileSize: $tileSize)
            .modifier(ToolbarModifier(type: drawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                                      tileSize: tileSize, isPlaying: isPlaying, perform: update))
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
                    tileSize: $tileSize)
        .modifier(ToolbarModifier(type: selectedDrawingType ?? Self.defaultDrawingType, foregroundColor: foregroundColor,
                                  backgroundColor: backgroundColor, tileSize: tileSize, isPlaying: isPlaying, perform: update))
        .modifier(NavigationBarModifier())
      }
      .navigationSplitViewStyle(.prominentDetail)
    }
  }

  private func update(action: ToolbarAction) {
    switch action {
    case .next: next()
    case let .setBackgroundColor(color): backgroundColor = color
    case let .setForegroundColor(color): foregroundColor = color
    case let .setTileSize(newTileSize): tileSize = newTileSize
    case .togglePlaying: isPlaying.toggle()
    case .toggleSidebarOrDismiss: toggleSidebar()
    }
  }

  private func next() {
    switch selectedDrawingType {
    case .none: break
    case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }

  private func toggleSidebar() {
    if horizontalSizeClass == .compact {
      selectedDrawingType = nil
      return
    }
    switch splitViewVisibility {
    case .all: splitViewVisibility = .detailOnly
    case .detailOnly: splitViewVisibility = .all
    default: break
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
