import SwiftUI

struct SizeControl: View {
  @Binding var size: CGFloat

  var body: some View {
    Slider(value: $size) { Text("Slider") }
      .padding(.horizontal, 24)
      .frame(width: 300)
  }
}

struct TileSizeControl {
  /// Expects a value from 0 to 1.
  static func widthForValue(_ value: CGFloat, viewSize: CGSize) -> CGFloat {
    let minWidth: CGFloat = 20
    guard viewSize.width > 0, viewSize.height > 0 else { return 0 }

    let width = min(viewSize.width, viewSize.height)
    let maxCount = Int(width / minWidth)

    guard maxCount > 1 else { return 0 }

    let value = 1 - max(0, min(1, value))
    let range = CGFloat(maxCount - 1)
    let count = 1 + round(range * value)
    return width / count
  }
}
