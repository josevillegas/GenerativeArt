import SwiftUI

struct ColorPickerView: View {
  @Binding var selectedColor: Color
  let horizontalSizeClass: UserInterfaceSizeClass?

  private let colors1: [Color] = [.black, .white, .red, .orange]
  private let colors2: [Color] = [.green, .yellow, .blue, .purple]

  var body: some View {
    Group {
      if horizontalSizeClass == .compact {
        VStack(spacing: 8) {
          ColorPickerRow(colors: colors1, selectedColor: $selectedColor)
          ColorPickerRow(colors: colors2, selectedColor: $selectedColor)
        }
      } else {
        ColorPickerRow(colors: colors1 + colors2, selectedColor: $selectedColor)
      }
    }
    .padding(16)
  }
}

struct ColorPickerRow: View {
  let colors: [Color]
  @Binding var selectedColor: Color

  var body: some View {
    HStack(spacing: 8) {
      ForEach(colors, id: \.hashValue) { color in
        ColorPickerItemView(color: color, isSelected: color == selectedColor)
          .onTapGesture { selectedColor = color }
      }
    }
  }
}

struct ColorPickerItemView: View {
  let color: Color
  let isSelected: Bool

  private let itemSize: CGFloat = 44

  var body: some View {
    ZStack {
      Circle()
        .fill(color)
        .stroke(strokeColor, style: StrokeStyle(lineWidth: 1))
        .frame(width: itemSize + selectionPadding, height: itemSize + selectionPadding)
      Circle()
        .fill(.clear)
        .strokeBorder(lineWidth: 4)
        .foregroundStyle(selectionColor)
        .frame(width: itemSize + 8, height: itemSize + 8)
    }
  }

  // Prevents artifacts from appearing between color circle and selection border.
  private var selectionPadding: CGFloat {
    isSelected ? 4 : 0
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
