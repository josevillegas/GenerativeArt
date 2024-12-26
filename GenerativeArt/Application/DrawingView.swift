import SwiftUI
import Combine

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
  @Binding var splitViewVisibility: NavigationSplitViewVisibility

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.dismiss) private var dismiss
  @State private var isPlaying: Bool = false
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
  @State private var timerCancellable: (any Cancellable)?

  private let timerDuration: TimeInterval = 2

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
    .onPreferenceChange(DrawingViewSizePreferenceKey.self) { _ in updateDrawing() }
    .modifier(ToolbarModifier(type: drawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor, tileSize: tileSize,
                              isPlaying: isPlaying, perform: update))
    .onChange(of: drawingType) { _, _ in updateForDrawingType() }
    .onReceive(timer) { _ in updateDrawing() }
    .onDisappear { timerCancellable?.cancel() }
    .onChange(of: isPlaying) { _, _ in updateForIsPlaying() }
  }

  private func updateForDrawingType() {
    if isPlaying {
      isPlaying = false
    }
    updateDrawing()
  }

  private func updateDrawing() {
    switch drawingType {
    case let .tile(type): tiledDrawingType = TiledDrawingTypeWrapper(type: type)
    case .paintingStyle(.mondrian): mondrianDrawing = MondrianDrawing()
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

  private func toggleSidebar() {
    if horizontalSizeClass == .compact {
      dismiss()
      return
    }
    switch splitViewVisibility {
    case .all: splitViewVisibility = .detailOnly
    case .detailOnly: splitViewVisibility = .all
    default: break
    }
  }

  private func next() {
    switch drawingType {
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
