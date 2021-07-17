struct AppConfiguration: Configuration {
  var sections: [Index.Section] {
    [
      Index.Section(title: "Lines", rows: [
        .drawing(.tile(.diagonals)),
        .drawing(.tile(.scribbles))
      ]),
      Index.Section(title: "Shapes", rows: [
        .drawing(.tile(.triangles)),
        .drawing(.tile(.quadrants)),
        .drawing(.tile(.trianglesAndQuadrants)),
        .drawing(.tile(.concentricShapes))
      ]),
      Index.Section(title: "Painting Styles", rows: [
        .drawing(.paintingStyle(.mondrian))
      ])
    ]
  }
}
