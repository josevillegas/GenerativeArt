import Foundation

enum DrawingType {
  case tile(TiledDrawingType)
  case paintingStyle(PaintingStyle)

  var title: String {
    switch self {
    case let .paintingStyle(style): return style.title
    case let .tile(type): return type.title
    }
  }
}

enum PaintingStyle {
  case mondrian

  var title: String {
    switch self {
    case .mondrian: return "Mondrian"
    }
  }
}

enum DrawingPresentationMode {
  case pushed
  case secondary
}
