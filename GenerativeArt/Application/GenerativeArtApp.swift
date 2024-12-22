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
  @State private var selectedDrawingType: DrawingType?

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingType: drawingType)
          }
      }
    } else {
      NavigationSplitView {
        SidebarView(selectedDrawingType: $selectedDrawingType)
      } detail: {
        if let selectedDrawingType {
          DrawingView(drawingType: selectedDrawingType)
        } else {
          Text("Select an item")
        }
      }
    }
  }
}
