import SwiftUI

enum ToolbarAction {
  case next
  case setBackgroundColor(Color)
  case setForegroundColor(Color)
  case setTileSize(CGFloat)
  case togglePlaying
  case toggleSidebarOrDismiss
}

struct ToolbarModifier: ViewModifier {
  let type: TiledDrawingType
  let foregroundColor: Color
  let backgroundColor: Color
  let tileSize: CGFloat
  let dismissImageName: String
  let playImageName: String
  let perform: (ToolbarAction) -> Void

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State var isForegroundColorPopoverPresented = false
  @State var isBackgroundColorPopoverPresented = false
  @State var isSizeControlPresented = false

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: { perform(.toggleSidebarOrDismiss) }) { Image(systemName: dismissImageName) }
          if showColorOptions {
            Spacer()
            Button("Front") { isForegroundColorPopoverPresented = true }
              .popover(isPresented: $isForegroundColorPopoverPresented) {
                ColorPickerView(selectedColor: foregroundColor, horizontalSizeClass: horizontalSizeClass) { perform(.setForegroundColor($0)) }
                  .presentationCompactAdaptation(.popover)
              }
            if showBackgroundColorOption {
              Spacer()
              Button("Back") { isBackgroundColorPopoverPresented = true }
                .popover(isPresented: $isBackgroundColorPopoverPresented) {
                  ColorPickerView(selectedColor: backgroundColor, horizontalSizeClass: horizontalSizeClass) { perform(.setBackgroundColor($0)) }
                    .presentationCompactAdaptation(.popover)
                }
            }
          }
          Spacer()
          Button("Size") { isSizeControlPresented = true }
            .popover(isPresented: $isSizeControlPresented) {
              SizeControl(size: Binding(get: { tileSize }, set: { value, transaction in perform(.setTileSize(value)) }))
                .presentationCompactAdaptation(.popover)
            }
          Spacer()
          Button(action: { perform(.togglePlaying) }) { Image(systemName: playImageName) }
            .frame(width: 44) // Keep width consistent when image changes.
          Spacer()
          Button(action: { perform(.next) }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }

  private var showColorOptions: Bool {
    switch type {
    case .concentricShapes: false
    default: true
    }
  }

  private var showBackgroundColorOption: Bool {
    switch type {
    case .scribbles: false
    default: true
    }
  }
}

struct PaintingToolbarModifier: ViewModifier {
  let dismissImageName: String
  let playImageName: String
  let perform: (ToolbarAction) -> Void

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: { perform(.toggleSidebarOrDismiss) }) { Image(systemName: dismissImageName) }
          Spacer()
          Button(action: { perform(.togglePlaying) }) { Image(systemName: playImageName) }
            .frame(width: 44) // Keep width consistent when image changes.
          Spacer()
          Button(action: { perform(.next) }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }
}
