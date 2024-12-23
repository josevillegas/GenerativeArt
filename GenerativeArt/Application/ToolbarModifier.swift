import SwiftUI

struct ToolbarModifier: ViewModifier {
  let next: () -> Void

  @State var isForegroundColorPopoverPresented = false

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button("Front") { isForegroundColorPopoverPresented = true }
            .popover(isPresented: $isForegroundColorPopoverPresented) {
              Text("Ok now")
            }
          Spacer()
          Button("Back") {}
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
