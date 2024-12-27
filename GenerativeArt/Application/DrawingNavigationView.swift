import SwiftUI

struct DrawingNavigationView: View {
  let drawingID: UUID
  @Binding var selectedDrawingType: DrawingType?
  @Binding var splitViewVisibility: NavigationSplitViewVisibility
  @Binding var foregroundColor: Color
  @Binding var backgroundColor: Color
  @Binding var tileSize: CGFloat
  @Binding var isPlaying: Bool
  let perform: (ToolbarAction) -> Void

  static let defaultDrawingType: DrawingType = .tile(.triangles)

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  var body: some View {
    if horizontalSizeClass == .compact {
      NavigationStack {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationTitle("Generative Art")
          .navigationDestination(item: $selectedDrawingType) { drawingType in
            DrawingView(drawingID: drawingID, drawingType: drawingType, foregroundColor: foregroundColor, backgroundColor: backgroundColor,
                        tileSize: tileSize)
            .modifier(ToolbarModifier(type: drawingType, foregroundColor: $foregroundColor, backgroundColor: $backgroundColor,
                                      tileSize: $tileSize, isPlaying: $isPlaying, perform: perform))
            .modifier(NavigationBarModifier())
          }
      }
    } else {
      NavigationSplitView(columnVisibility: $splitViewVisibility) {
        SidebarView(selectedDrawingType: $selectedDrawingType)
          .navigationTitle("Generative Art")
          .toolbar(removing: .sidebarToggle)
      } detail: {
        DrawingView(drawingID: drawingID, drawingType: selectedDrawingType ?? Self.defaultDrawingType, foregroundColor: foregroundColor,
                    backgroundColor: backgroundColor, tileSize: tileSize)
        .modifier(ToolbarModifier(type: selectedDrawingType ?? Self.defaultDrawingType, foregroundColor: $foregroundColor,
                                  backgroundColor: $backgroundColor, tileSize: $tileSize, isPlaying: $isPlaying, perform: perform))
        .modifier(NavigationBarModifier())
      }
      .navigationSplitViewStyle(.prominentDetail)
    }
  }
}
