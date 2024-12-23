import SwiftUI

struct ToolbarModifier: ViewModifier {
  @Binding var selectedForegroundColor: Color
  @Binding var selectedBackgroundColor: Color
  let next: () -> Void

  @State var isForegroundColorPopoverPresented = false
  @State var isBackgroundColorPopoverPresented = false

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button("Front") { isForegroundColorPopoverPresented = true }
            .popover(isPresented: $isForegroundColorPopoverPresented) {
              ColorPickerView(selectedColor: $selectedForegroundColor)
                .presentationCompactAdaptation(.popover)
            }
          Spacer()
          Button("Back") { isBackgroundColorPopoverPresented = true }
            .popover(isPresented: $isBackgroundColorPopoverPresented) {
              ColorPickerView(selectedColor: $selectedBackgroundColor)
                .presentationCompactAdaptation(.popover)
            }
          Spacer()
          Button("Size") {}
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
  let next: () -> Void

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: {}) { Image(systemName: "play") }
          Spacer()
          Button(action: { next() }) { Image(systemName: "goforward") }
          Spacer()
        }
      }
  }
}
