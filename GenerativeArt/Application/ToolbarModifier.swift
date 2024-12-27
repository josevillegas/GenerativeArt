import SwiftUI

enum ToolbarAction {
  case next
  case toggleSidebar
}

struct ToolbarModifier: ViewModifier {
  let type: DrawingType
  @Binding var foregroundColor: Color
  @Binding var backgroundColor: Color
  @Binding var tileSize: CGFloat
  @Binding var isPlaying: Bool
  let perform: (ToolbarAction) -> Void

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State private var isForegroundColorPopoverPresented = false
  @State private var isBackgroundColorPopoverPresented = false
  @State private var isSizeControlPresented = false

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: { perform(.toggleSidebar) }) { Image(systemName: dismissImageName) }
          if showColorOptions {
            Spacer()
            Button("Front") { isForegroundColorPopoverPresented = true }
              .popover(isPresented: $isForegroundColorPopoverPresented) {
                ColorPickerView(selectedColor: foregroundColor, horizontalSizeClass: horizontalSizeClass) { foregroundColor = $0 }
                  .presentationCompactAdaptation(.popover)
              }
            Spacer()
            Button("Back") { isBackgroundColorPopoverPresented = true }
              .popover(isPresented: $isBackgroundColorPopoverPresented) {
                ColorPickerView(selectedColor: backgroundColor, horizontalSizeClass: horizontalSizeClass) { backgroundColor = $0 }
                  .presentationCompactAdaptation(.popover)
              }
          }
          if showSizeOption {
            Spacer()
            Button("Size") { isSizeControlPresented = true }
              .popover(isPresented: $isSizeControlPresented) {
                SizeControl(size: $tileSize)
                  .presentationCompactAdaptation(.popover)
              }
          }
          Spacer()
          Button(action: { isPlaying.toggle() }) { Image(systemName: playImageName) }
            .frame(width: 44) // Keep width consistent when image changes.
          Spacer()
          Button(action: { perform(.next) }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }

  private var showColorOptions: Bool {
    switch type {
    case .tile(.concentricShapes), .paintingStyle(.mondrian): false
    case .tile: true
    }
  }

  private var showSizeOption: Bool {
    switch type {
    case .paintingStyle(.mondrian): false
    case .tile: true
    }
  }

  private var dismissImageName: String {
    horizontalSizeClass == .compact ?  "chevron.backward" : "sidebar.leading"
  }

  private var playImageName: String {
    isPlaying ? "pause" : "play"
  }
}
