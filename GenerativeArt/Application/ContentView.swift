import SwiftUI
import Combine

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
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var timerCancellable: (any Cancellable)?

  private let timerDuration: TimeInterval = 2

  var body: some View {
    Group {
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
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { _ in updateDrawing() }
    .onChange(of: selectedDrawingType) { _, _ in updateForDrawingType() }
    .onReceive(timer) { _ in updateDrawing() }
    .onDisappear { timerCancellable?.cancel() }
    .onChange(of: isPlaying) { _, _ in updateForIsPlaying() }
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

  private func updateForDrawingType() {
    if isPlaying {
      isPlaying = false
    }
    updateDrawing()
  }

  private func updateDrawing() {
    switch selectedDrawingType {
    case .none: break
    case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
    }
  }

  private func updateForIsPlaying() {
    timerCancellable?.cancel()
    timerCancellable = nil
    if isPlaying {
      timer = Timer.publish(every: timerDuration, on: .main, in: .common)
      timerCancellable = timer.connect()
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