import Foundation

enum DrawingType {
  case tile(TiledDrawingType)
  case paintingStyle(PaintingStyle)
}

enum PaintingStyle {
  case mondrian
}
