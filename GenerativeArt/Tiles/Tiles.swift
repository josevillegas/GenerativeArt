import Foundation

struct Tiles {
  let maxSize: CGSize
  let maxTileSize: CGFloat
  let scale: CGFloat?
  let size: CGSize
  let tileSize: CGSize
  let frames: [CGRect]

  /// Use the `scale` property to align the tiles to the screen pixels.
  /// The `scale` value represents the number of pixels per point.
  init(maxSize: CGSize, maxTileSize: CGFloat, scale: CGFloat? = nil) {
    self.maxSize = maxSize
    self.maxTileSize = maxTileSize
    self.scale = scale

    guard maxSize.width > 0, maxSize.height > 0, maxTileSize > 0 else {
      size = maxSize
      tileSize = maxSize
      frames = []
      return
    }
    let xCount = floor(maxSize.width / maxTileSize)
    let xStep = Tiles.roundedForScale(maxSize.width / xCount, scale: scale)
    let yCount = floor(maxSize.height / maxTileSize)
    let yStep = Tiles.roundedForScale(maxSize.height / yCount, scale: scale)
    let step = min(xStep, yStep)
    let tileSize = CGSize(width: step, height: step)
    self.tileSize = tileSize

    let size = scale == nil ? maxSize : CGSize(width: step * xCount, height: step * yCount)
    self.size = size

    frames = stride(from: 0, to: size.width, by: step).flatMap { x in
      stride(from: 0, to: size.height, by: step).map { y in
        CGRect(origin: CGPoint(x: x, y: y), size: tileSize)
      }
    }
  }

  static func roundedForScale(_ value: CGFloat, scale: CGFloat?) -> CGFloat {
    guard let scale = scale else { return value }
    return floor(value * scale) / scale
  }
}
