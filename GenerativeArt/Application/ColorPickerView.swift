import SwiftUI

struct ColorPickerView: View {
  @Binding var selectedColor: Color
  let horizontalSizeClass: UserInterfaceSizeClass?

  private let colors: [Color] = [.black, .white, .red, .orange, .green, .yellow, .blue, .purple]

  var body: some View {
    HStack(spacing: horizontalSizeClass == .compact ? 0 : 8) {
      ForEach(colors, id: \.hashValue) { color in
        ColorPickerItemView(color: color, isSelected: color == selectedColor, horizontalSizeClass: horizontalSizeClass)
          .onTapGesture { selectedColor = color }
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
        .fill(color)
        .stroke(strokeColor, style: StrokeStyle(lineWidth: 1))
        .frame(width: fillCircleSize, height: fillCircleSize)
      Circle()
        .fill(.clear)
        .strokeBorder(lineWidth: selectionBorderWidth)
        .foregroundStyle(selectionColor)
        .frame(width: strokeCircleSize, height: strokeCircleSize)
    }
  }

  private var fillCircleSize: CGFloat {
    itemSize + selectionPadding
  }

  private var strokeCircleSize: CGFloat {
    itemSize + selectionBorderWidth * 2
  }

  private var itemSize: CGFloat {
    horizontalSizeClass == .compact ? 34 : 44
  }

  // Prevents artifacts from appearing between color circle and selection border.
  private var selectionPadding: CGFloat {
    isSelected ? 4 : 0
  }

  private var selectionBorderWidth: CGFloat {
    horizontalSizeClass == .compact ? 3 : 4
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
