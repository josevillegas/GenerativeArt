import Foundation

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
}
