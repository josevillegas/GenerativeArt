import SwiftUI

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

  var defaultForegroundColor: Color {
    switch self {
    case .scribbles: .black
    default: .red
    }
  }

  var defaultBackgroundColor: Color {
    .white
  }

  var backgroundColor: Color {
    switch self {
    case .scribbles: .lightGray
    default: .white
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

  var options: DrawingControls.Options {
    switch self {
    case .diagonals,
         .triangles,
         .quadrants,
         .trianglesAndQuadrants: .all
    case .concentricShapes,
         .scribbles: [.size]
    }
  }

  func paths(frame: CGRect, foregroundColor: Color, backgroundColor: Color) -> [GAPath] {
    switch self {
    case .concentricShapes:
      let colors: [Color] = [.black, .lightGray, .red, .orange, .purple, .white]
      return GAPath.concentricShapePaths(frame: frame, colors: colors)
    case .diagonals:
      return [
        .fillRect(frame, color: backgroundColor),
        .randomDiagonal(frame, color: foregroundColor)
      ]
    case .triangles:
      return [
        .fillRect(frame, color: backgroundColor),
        .randomTriangle(frame, color: foregroundColor)
      ]
    case .quadrants:
      return [
        .fillRect(frame, color: backgroundColor),
        .randomQuarterCircle(frame, color: foregroundColor)
      ]
    case .trianglesAndQuadrants:
      return [
        .fillRect(frame, color: backgroundColor),
        .randomTrianglesAndQuarterCircles(frame, color: foregroundColor)
      ]
    case .scribbles:
      return [
        .scribble(frame, color: foregroundColor)
      ]
    }
  }
}
