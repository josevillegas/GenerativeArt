import SwiftUI

struct ToolbarModifier: ViewModifier {
  @Binding var foregroundColor: Color
  @Binding var backgroundColor: Color
  @Binding var tileSize: CGFloat
  let dismissImageName: String
  let toggleSidebar: () -> Void
  let next: () -> Void

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State var isForegroundColorPopoverPresented = false
  @State var isBackgroundColorPopoverPresented = false
  @State var isSizeControlPresented = false

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: { toggleSidebar() }) { Image(systemName: dismissImageName) }
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
          Spacer()
          Button("Size") { isSizeControlPresented = true }
            .popover(isPresented: $isSizeControlPresented) {
              SizeControl(size: $tileSize)
                .presentationCompactAdaptation(.popover)
            }
          Spacer()
          Button(action: {}) { Image(systemName: "play") }
          Spacer()
          Button(action: { next() }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }
}

struct PaintingToolbarModifier: ViewModifier {
  let dismissImageName: String
  let toggleSidebar: () -> Void
  let next: () -> Void

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: { toggleSidebar() }) { Image(systemName: dismissImageName) }
          Spacer()
          Button(action: {}) { Image(systemName: "play") }
          Spacer()
          Button(action: { next() }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }
}