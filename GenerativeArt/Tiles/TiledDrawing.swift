import SwiftUI

struct TiledDrawing: Equatable {
  var paths: [GAPath] { return tilePaths.flatMap { $0 } }
  var foregroundColor: Color
  var backgroundColor: Color

  var type: TiledDrawingType {
    didSet {
      unitSize = type.defaultUnitSize
      foregroundColor = type.defaultForegroundColor
      backgroundColor = type.defaultBackgroundColor
    }
  }
  var maxSize: CGSize = .zero {
    didSet { updateSize() }
  }
  var unitSize: CGFloat {
    didSet { updateSize() }
  }
  private(set) var size: CGSize = .zero
  private(set) var tileSize: CGSize = .zero

  private var frames: [CGRect] = []
  private var tilePaths: [[GAPath]] = []

  init(type: TiledDrawingType) {
    self.type = type
    unitSize = type.defaultUnitSize
    foregroundColor = type.defaultForegroundColor
    backgroundColor = type.defaultBackgroundColor
  }

  mutating func updateVariations() {
    tilePaths = frames.map { makePaths(frame: $0) }
  }

  mutating func updateRandomTile() {
    guard !tilePaths.isEmpty, tilePaths.count == frames.count else { return }
    let index = Int.random(in: 0..<frames.count)
    tilePaths[index] = makePaths(frame: frames[index])
  }

  private func makePaths(frame: CGRect) -> [GAPath] {
    type.paths(frame: frame, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
  }

  private mutating func updateSize() {
    let tiles = Tiles(maxSize: maxSize, maxTileSize: unitSize, scale: UIScreen.main.scale)
    frames = tiles.frames
    size = tiles.size
    tileSize = tiles.tileSize
  }
}
