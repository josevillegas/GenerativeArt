import SwiftUI

struct ColorPickerView: View {
  @Binding var selectedColor: Color

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  private let colors: [Color] = [.black, .white, .red, .orange, .green, .yellow, .blue, .purple]

  var body: some View {
    HStack(spacing: horizontalSizeClass == .compact ? 0 : 8) {
      ForEach(colors, id: \.hashValue) { color in
        ColorPickerItemView(color: color, isSelected: color == selectedColor, horizontalSizeClass: horizontalSizeClass)
      }
    }
    .padding(.horizontal, 16)
  }
}

struct ColorPickerItemView: View {
  let color: Color
  let isSelected: Bool
  let horizontalSizeClass: UserInterfaceSizeClass?

  var body: some View {
    ZStack {
      Circle()
        .fill(selectionColor)
        .frame(width: selectionSize, height: selectionSize)
      Circle()
        .fill(color)
        .stroke(strokeColor, style: StrokeStyle(lineWidth: 1))
        .frame(width: itemSize, height: itemSize)
    }
  }

  private var itemSize: CGFloat {
    horizontalSizeClass == .compact ? 34 : 44
  }

  private var selectionSize: CGFloat {
    itemSize + (horizontalSizeClass == .compact ? 6 : 8)
  }

  private var selectionColor: Color {
    !isSelected ? .clear : color == .blue ? .red : .blue
  }

  private var strokeColor: Color {
    switch color {
    case .white: .gray.opacity(0.5)
    case .black: .white.opacity(0.5)
    default: .clear
    }
  }
}
