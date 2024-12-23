import SwiftUI

struct TiledDrawing: Equatable {
  let type: TiledDrawingType
  var paths: [GAPath] { return tilePaths.flatMap { $0 } }
  let foregroundColor: Color
  let backgroundColor: Color

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
    foregroundColor = type.defaultForegroundColor.color()
    backgroundColor = type.defaultBackgroundColor.color()
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
    type.paths(PathProperties(frame: frame, foregroundColor: foregroundColor, backgroundColor: backgroundColor))
  }

  private mutating func updateSize() {
    let tiles = Tiles(maxSize: maxSize, maxTileSize: unitSize, scale: UIScreen.main.scale)
    frames = tiles.frames
    size = tiles.size
    tileSize = tiles.tileSize
  }
}

extension TiledDrawing {
  struct PathProperties: Equatable {
    let frame: CGRect
    let foregroundColor: Color
    let backgroundColor: Color
  }
}
