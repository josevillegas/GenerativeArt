import SwiftUI

struct TiledDrawing: Equatable {
  var paths: [GAPath] { return tilePaths.flatMap { $0 } }
  var foregroundColor: Color = .red
  var backgroundColor: Color = .white

  var type: TiledDrawingType
  var tiles: Tiles

  private var tilePaths: [[GAPath]] = []

  init(type: TiledDrawingType, tiles: Tiles) {
    self.type = type
    self.tiles = tiles
  }

  init() {
    type = .triangles
    tiles = Tiles(maxSize: .zero, maxTileSize: 0)
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
