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