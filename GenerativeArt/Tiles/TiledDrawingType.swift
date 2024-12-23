import CoreGraphics

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

  var defaultForegroundColor: GAColor {
    switch self {
    case .scribbles: .black
    default: .red
    }
  }

  var defaultBackgroundColor: GAColor {
    .white
  }

  var backgroundColor: GAColor {
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

  var paths: (TiledDrawing.PathProperties) -> [GAPath] {
    switch self {
    case .concentricShapes:
      let colors: [GAColor] = [.black, .lightGray, .red, .orange, .purple, .white]
      return {
        GAPath.concentricShapePaths(frame: $0.frame, colors: colors.map { $0.color() })
      }
    case .diagonals:
      return {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomDiagonal($0.frame, color: $0.foregroundColor)
      ]}
    case .triangles:
      return {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomTriangle($0.frame, color: $0.foregroundColor)
      ]}
    case .quadrants:
      return {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomQuarterCircle($0.frame, color: $0.foregroundColor)
      ]}
    case .trianglesAndQuadrants:
      return {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomTrianglesAndQuarterCircles($0.frame, color: $0.foregroundColor)
      ]}
    case .scribbles:
      return {[
        .scribble($0.frame, color: $0.foregroundColor)
      ]}
    }
  }
}
