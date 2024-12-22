import Foundation

enum DrawingType: Hashable {
  case tile(TiledDrawingType)
  case paintingStyle(PaintingStyle)

  var title: String {
    switch self {
    case let .paintingStyle(style): style.title
    case let .tile(type): type.title
    }
  }
}

enum PaintingStyle {
  case mondrian

  var title: String {
    switch self {
    case .mondrian: "Mondrian"
    }
  }
}

enum DrawingPresentationMode {
  case pushed
  case secondary
}
