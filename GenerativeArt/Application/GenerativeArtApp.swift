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
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State private var selectedDrawingType: DrawingType? = Self.defaultDrawingType
  @State private var splitViewVisibility: NavigationSplitViewVisibility = .all

  static let defaultDrawingType: DrawingType = .tile(.triangles)

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingType: drawingType, splitViewVisibility: $splitViewVisibility)
              .toolbarVisibility(.hidden, for: .navigationBar)
          }
      }
    } else {
      NavigationSplitView(columnVisibility: $splitViewVisibility) {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationTitle("Generative Art")
          .toolbar(removing: .sidebarToggle)
      } detail: {
        DrawingView(drawingType: selectedDrawingType ?? Self.defaultDrawingType, splitViewVisibility: $splitViewVisibility)
          .toolbarVisibility(.hidden, for: .navigationBar)
      }
      .navigationSplitViewStyle(.prominentDetail)
    }
  }
}
