import Foundation

enum DrawingType {
  case tile(TiledDrawingType)
  case paintingStyle(PaintingStyle)
}

enum PaintingStyle {
  case mondrian

  var title: String {
    switch self {
    case .mondrian: return "Mondrian"
    }
  }
}
