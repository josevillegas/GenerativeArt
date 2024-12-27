import Foundation

enum DrawingType: Hashable, Identifiable {
  case tile(TiledDrawingType)
  case paintingStyle(PaintingStyle)

  var id: String { title }

  var title: String {
    switch self {
    case let .paintingStyle(style): style.title
    case let .tile(type): type.title
    }
  }

  static let defaultType: DrawingType = .tile(.triangles)
}

enum PaintingStyle {
  case mondrian

  var title: String {
    switch self {
    case .mondrian: "Mondrian"
    }
  }
}
