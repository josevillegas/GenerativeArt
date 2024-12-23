import SwiftUI

struct TiledDrawing: Equatable {
  var paths: [GAPath] { return tilePaths.flatMap { $0 } }
  var foregroundColor: Color
  var backgroundColor: Color
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
  private let makePaths: MakePaths

  init(unitSize: CGFloat, foregroundColor: Color, backgroundColor: Color, makePaths: @escaping (PathProperties) -> [GAPath]) {
    self.unitSize = unitSize
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.makePaths = MakePaths(makePaths: makePaths)
  }

  init(type: TiledDrawingType) {
    self.init(
      unitSize: type.defaultUnitSize,
      foregroundColor: type.defaultForegroundColor.color(),
      backgroundColor: type.defaultBackgroundColor.color(),
      makePaths: type.paths
    )
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
  struct PathProperties: Equatable {
    let frame: CGRect
    let foregroundColor: Color
    let backgroundColor: Color
  }

  struct MakePaths: Equatable {
    let makePaths: (PathProperties) -> [GAPath]
    func callAsFunction(_ properties: PathProperties) -> [GAPath] {
      makePaths(properties)
    }
    static func ==(_ lhs: MakePaths, _ rhs: MakePaths) -> Bool { true }
  }
}
