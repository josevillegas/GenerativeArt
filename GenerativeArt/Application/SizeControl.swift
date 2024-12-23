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
  private let maxCount: Int
  private let width: CGFloat

  init(boundsSize: CGSize, minWidth: CGFloat) {
    guard boundsSize.width > 0, boundsSize.height > 0, minWidth > 0 else {
      maxCount = 0
      width = 0
      return
    }
    width = min(boundsSize.width, boundsSize.height)
    maxCount = Int(width / minWidth)
  }

  /// Expects a value from 0 to 1.
  func widthForValue(_ value: CGFloat) -> CGFloat {
    guard maxCount > 1, width > 0 else { return 0 }

    let value = 1 - max(0, min(1, value))
    let range = CGFloat(maxCount - 1)
    let count = 1 + round(range * value)
    return width / count
  }

  static var empty: TileSizeControl {
    TileSizeControl(boundsSize: .zero, minWidth: 0)
  }
}
