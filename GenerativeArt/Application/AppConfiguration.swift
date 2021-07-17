struct AppConfiguration: Configuration {
  var sections: [Index.Section] {
    [
      Index.Section(title: "Lines", rows: [
        .tiledDrawing(.diagonals),
        .tiledDrawing(.scribbles)
      ]),
      Index.Section(title: "Shapes", rows: [
        .tiledDrawing(.triangles),
        .tiledDrawing(.quadrants),
        .tiledDrawing(.trianglesAndQuadrants),
        .tiledDrawing(.concentricShapes),
      ]),
      Index.Section(title: "Painting Styles", rows: [
        .paintingStyle(.mondrian)
      ])
    ]
  }
}
