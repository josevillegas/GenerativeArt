import SwiftUI

struct ColorPickerView: View {
  private let colors: [Color] = [.black, .white, .red, .orange, .green, .yellow, .blue, .purple]

  var body: some View {
    HStack {
      ForEach(colors, id: \.hashValue) { color in
        ColorPickerItemView(color: color)
      }
    }
    .padding(.horizontal, 12)
  }
}

struct ColorPickerItemView: View {
  let color: Color

  var body: some View {
    Circle()
      .fill(color)
      .frame(width: 44, height: 44)
  }
}
