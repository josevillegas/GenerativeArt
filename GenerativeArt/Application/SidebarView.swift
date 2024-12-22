import SwiftUI

struct SidebarView: View {
  let sections: [IndexSection]
  @Binding var selectedDrawingType: DrawingType?

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
