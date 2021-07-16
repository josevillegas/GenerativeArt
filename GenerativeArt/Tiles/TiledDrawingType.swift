import Foundation

enum TiledDrawingType {
  case concentricShapes
  case tiledLines
  case kellyTiles1
  case kellyTiles2
  case kellyTiles3
  case scribbles

  var title: String {
    switch self {
    case .concentricShapes: return "Concentric Shapes"
    case .tiledLines: return "Tiled Lines"
    case .kellyTiles1: return "Kelly Tiles"
    case .kellyTiles2: return "Kelly Tiles 2"
    case .kellyTiles3: return "Kelly Tiles 3"
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
