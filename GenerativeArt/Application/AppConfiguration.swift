struct AppConfiguration: Configuration {
  var sections: [Index.Section] {
    [
      Index.Section(title: "Lines", rows: [
        .tile(.diagonals),
        .tile(.scribbles)
      ]),
      Index.Section(title: "Shapes", rows: [
        .tile(.triangles),
        .tile(.quadrants),
        .tile(.trianglesAndQuadrants),
        .tile(.concentricShapes)
      ]),
      Index.Section(title: "Painting Styles", rows: [
        .paintingStyle(.mondrian)
      ])
    ]
  }
}
