import UIKit

struct TiledDrawing {
  struct PathProperties {
    let frame: CGRect
    let foregroundColor: UIColor
    let backgroundColor: UIColor
  }

  var paths: [Path] { return tilePaths.flatMap { $0 } }
  var foregroundColor: UIColor
  var backgroundColor: UIColor
  var maxSize: CGSize = .zero {
    didSet { updateSize() }
  }
  var unitSize: CGFloat {
    didSet { updateSize() }
  }
  private(set) var size: CGSize = .zero
  private(set) var tileSize: CGSize = .zero

  private var frames: [CGRect] = []
  private var tilePaths: [[Path]] = []
  private let makePaths: (PathProperties) -> [Path]

  init(unitSize: CGFloat, foregroundColor: UIColor, backgroundColor: UIColor, makePaths: @escaping (PathProperties) -> [Path]) {
    self.unitSize = unitSize
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.makePaths = makePaths
  }

  mutating func updateVariations() {
    tilePaths = frames.map { makePaths(frame: $0) }
  }

  mutating func updateRandomTile() {
    guard !tilePaths.isEmpty, tilePaths.count == frames.count else { return }
    let index = Int.random(in: 0..<frames.count)
    tilePaths[index] = makePaths(frame: frames[index])
  }

  private func makePaths(frame: CGRect) -> [Path] {
    makePaths(PathProperties(frame: frame, foregroundColor: foregroundColor, backgroundColor: backgroundColor))
  }

  private mutating func updateSize() {
    let tiles = Tiles(maxSize: maxSize, maxTileSize: unitSize, scale: UIScreen.main.scale)
    frames = tiles.frames
    size = tiles.size
    tileSize = tiles.tileSize
  }
}

extension TiledDrawing {
  init(variation: TiledDrawingType, foregroundColor: UIColor, backgroundColor: UIColor) {
    switch variation {
    case .concentricShapes:
      let colors: [Color] = [.black, .lightGray, .red, .orange, .purple, .white]
      self.init(unitSize: 30, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {
        Path.concentricShapePaths(frame: $0.frame, colors: colors.map { $0.color() })
      }
    case .tiledLines:
      self.init(unitSize: 15, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomDiagonal($0.frame, color: $0.foregroundColor)
      ]}
    case .kellyTiles1:
      self.init(unitSize: 30, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomTriangle($0.frame, color: $0.foregroundColor)
      ]}
    case .kellyTiles2:
      self.init(unitSize: 30, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomQuarterCircle($0.frame, color: $0.foregroundColor)
      ]}
    case .kellyTiles3:
      self.init(unitSize: 30, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {[
        .fillRect($0.frame, color: $0.backgroundColor),
        .randomTrianglesAndQuarterCircles($0.frame, color: $0.foregroundColor)
      ]}
    case .scribbles:
      self.init(unitSize: 30, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {[
        .scribble($0.frame, color: $0.foregroundColor)
      ]}
    }
  }
}
