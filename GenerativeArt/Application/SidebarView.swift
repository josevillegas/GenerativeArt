import SwiftUI

struct SidebarView: View {
  @Binding var selectedDrawingType: DrawingType?

  private let sections = [
    IndexSection(title: "Lines", rows: [
      .tile(.diagonals),
      .tile(.scribbles)
    ]),
    IndexSection(title: "Shapes", rows: [
      .tile(.triangles),
      .tile(.quadrants),
      .tile(.trianglesAndQuadrants),
      .tile(.concentricShapes)
    ]),
    IndexSection(title: "Painting Styles", rows: [
      .paintingStyle(.mondrian)
    ])
  ]

  var body: some View {
    List(selection: $selectedDrawingType) {
      ForEach(sections) { section in
        Section(section.title) {
          ForEach(section.rows) { row in
            NavigationLink(value: row) { Text(row.title).padding(.leading, 12) }
          }
        }
      }
    }
  }
}
