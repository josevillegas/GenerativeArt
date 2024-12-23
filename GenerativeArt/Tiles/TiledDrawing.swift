import SwiftUI

struct TiledDrawing: Equatable {
  var paths: [GAPath] { return tilePaths.flatMap { $0 } }
  var foregroundColor: Color
  var backgroundColor: Color

  var type: TiledDrawingType {
    didSet {
      foregroundColor = type.defaultForegroundColor
      backgroundColor = type.defaultBackgroundColor
    }
  }
  var tiles: Tiles

  private var tilePaths: [[GAPath]] = []

  init(type: TiledDrawingType, tiles: Tiles) {
    self.type = type
    self.tiles = tiles
    foregroundColor = type.defaultForegroundColor
    backgroundColor = type.defaultBackgroundColor
  }

  mutating func updateVariations() {
    tilePaths = tiles.frames.map { makePaths(frame: $0) }
  }

  mutating func updateRandomTile() {
    guard !tilePaths.isEmpty, tilePaths.count == tiles.frames.count else { return }
    let index = Int.random(in: 0..<tiles.frames.count)
    tilePaths[index] = makePaths(frame: tiles.frames[index])
  }

  private func makePaths(frame: CGRect) -> [GAPath] {
    type.paths(frame: frame, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
  }
}
