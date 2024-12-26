import SwiftUI

// This is needed so that the UIViewRepresentable registers changes.
struct TiledDrawingTypeWrapper: Equatable {
  let id = UUID()
  let type: TiledDrawingType
}

enum TiledDrawingType {
  case concentricShapes
  case diagonals
  case triangles
  case quadrants
  case trianglesAndQuadrants
  case scribbles

  var title: String {
    switch self {
    case .concentricShapes: "Concentric Shapes"
    case .diagonals: "Diagonals"
    case .triangles: "Triangles"
    case .quadrants: "Quadrants"
    case .trianglesAndQuadrants: "Triangles and Quadrants"
    case .scribbles: "Scribbles"
    }
  }

  var defaultUnitSize: CGFloat {
    switch self {
    case .concentricShapes,
         .triangles,
         .quadrants,
         .trianglesAndQuadrants,
         .scribbles: 30
    case .diagonals: 15
    }
  }

  func paths(frame: CGRect, foregroundColor: Color, backgroundColor: Color) -> [GAPath] {
    switch self {
    case .concentricShapes: GAPath.concentricShapePaths(frame: frame, colors: [.black, Color(white: 0.9), .red, .orange, .purple, .white])
    case .diagonals:
      [
        .fillRect(frame, color: backgroundColor),
        .randomDiagonal(frame, color: foregroundColor)
      ]
    case .triangles:
      [
        .fillRect(frame, color: backgroundColor),
        .randomTriangle(frame, color: foregroundColor)
      ]
    case .quadrants:
      [
        .fillRect(frame, color: backgroundColor),
        .randomQuarterCircle(frame, color: foregroundColor)
      ]
    case .trianglesAndQuadrants:
      [
        .fillRect(frame, color: backgroundColor),
        .randomTrianglesAndQuarterCircles(frame, color: foregroundColor)
      ]
    case .scribbles: [.scribble(frame, color: foregroundColor)]
    }
  }
}
