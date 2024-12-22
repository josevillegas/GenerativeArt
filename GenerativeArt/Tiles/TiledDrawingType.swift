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
    case .concentricShapes: return "Concentric Shapes"
    case .diagonals: return "Diagonals"
    case .triangles: return "Triangles"
    case .quadrants: return "Quadrants"
    case .trianglesAndQuadrants: return "Triangles and Quadrants"
    case .scribbles: return "Scribbles"
    }
  }

  var defaultForegroundColor: Color {
    switch self {
    case .scribbles: return .black
    default: return .red
    }
  }

  var defaultBackgroundColor: Color {
    .white
  }

  var backgroundColor: Color {
    switch self {
    case .scribbles: return .lightGray
    default: return .white
    }
  }

  var defaultUnitSize: CGFloat {
    switch self {
    case .concentricShapes,
         .triangles,
         .quadrants,
         .trianglesAndQuadrants,
         .scribbles:
      return 30
    case .diagonals:
      return 15
    }
  }

  var options: DrawingControls.Options {
    switch self {
    case .diagonals,
         .triangles,
         .quadrants,
         .trianglesAndQuadrants:
      return .all
    case .concentricShapes,
         .scribbles:
      return [.size]
    }
  }

  var paths: (TiledDrawing.PathProperties) -> [GAPath] {
    switch self {
    case .concentricShapes:
      let colors: [Color] = [.black, .lightGray, .red, .orange, .purple, .white]
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

extension TiledDrawingViewModel {
  init(type: TiledDrawingType) {
    self.init(
      options: type.options,
      backgroundColor: type.backgroundColor,
      tileForegroundColor: type.defaultForegroundColor,
      tileBackgroundColor: type.defaultBackgroundColor,
      defaultUnitSize: type.defaultUnitSize,
      paths: type.paths
    )
  }
}
