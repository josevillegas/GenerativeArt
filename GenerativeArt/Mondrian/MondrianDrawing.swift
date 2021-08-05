import UIKit

struct MondrianDrawing {
  private let colors: [UIColor] = [.red, .yellow, .blue]

  func paths(frame: CGRect) -> [Path] {
    let count = Int.random(in: 4...10)
    let (frames, lines) = reduce(frames: [frame], lines: [], count: count)
    let linePaths: [Path] = lines.map {
      let width = Bool.random() ? 7 : 8
      return Path(fillColor: nil, strokeColor: .black, lineWidth: CGFloat(width), commands: [
        .moveTo($0.start),
        .addLineTo($0.end),
        .close
      ])
    }
    return colorPaths(frames: frames) + linePaths
  }

  private func reduce(frames: [CGRect], lines: [Line], count: Int) -> ([CGRect], [Line]) {
    var frames = frames
    guard !frames.isEmpty, count > 0 else { return (frames, lines) }

    let index = Int.random(in: 0..<frames.count)
    let frame = frames.remove(at: index)
    let margin: CGFloat = 10
    // If the first split fails, try one more time.
    // We may hit a frame that is too narrow when other frames are available.
    guard let split = MondrianDrawing.Split(frame: frame, margin: margin) ?? MondrianDrawing.Split(frame: frame, margin: margin) else {
      return (frames, lines)
    }

    return reduce(frames: frames + split.frames, lines: lines + [split.line], count: count - 1)
  }

  private func colorPaths(frames: [CGRect]) -> [Path] {
    guard !frames.isEmpty else { return [] }

    // If there is only one frame, return a color path for it.
    guard frames.count > 1 else { return [colorPath(frames[0])] }

    // If there are two or three items, return a single color path.
    guard frames.count > 3 else {
      let index = Int.random(in: 0..<frames.count)
      return [colorPath(frames[index])]
    }

    let ratio = Double.random(in: 0.2...0.6)
    // Add color to a percentage of the frames.
    let countByRatio = Int(round(Double(frames.count) * ratio))
    // There should be a minimum of two colored frames.
    let count = max(2, countByRatio)

    var workFrames = frames
    var returnFrames: [CGRect] = []
    for _ in 1...count {
      let index = Int.random(in: 0..<workFrames.count)
      returnFrames.append(workFrames.remove(at: index))
    }
    return returnFrames.map { self.colorPath($0) }
  }

  private func colorPath(_ frame: CGRect) -> Path {
    Path(fillColor: colors.randomElement(), strokeColor: nil, commands: [Path.Command.addRect(frame)])
  }
}

extension MondrianDrawing {
  /// `Split` represents a rectangle split in two.
  struct Split {
    /// The first rectangle the primary rectangle is split into.
    let frame1: CGRect

    /// The second rectangle the primary rectangle is split into.
    let frame2: CGRect

    /// The line between the two rectangles in the split.
    let line: Line

    var frames: [CGRect] {
      [frame1, frame2]
    }
  }

  struct Line {
    let start: CGPoint
    let end: CGPoint
  }
}

extension MondrianDrawing.Split {
  init?(frame: CGRect, margin: CGFloat) {
    if Bool.random() {
      // Return two columns.
      let length = frame.size.width - margin * 2
      guard length > margin else { return nil }

      let offset = margin + round(CGFloat.random(in: margin...length))
      self.init(
        frame1: CGRect(x: frame.origin.x, y: frame.origin.y, width: offset, height: frame.size.height),
        frame2: CGRect(x: frame.origin.x + offset, y: frame.origin.y, width: frame.size.width - offset, height: frame.size.height),
        line: MondrianDrawing.Line(
          start: CGPoint(x: frame.origin.x + offset, y: frame.origin.y),
          end: CGPoint(x: frame.origin.x + offset, y: frame.origin.y + frame.size.height)
        )
      )
    } else {
      // Return two rows.
      let length = frame.size.height - margin * 2
      guard length > margin else { return nil }

      let offset = margin + round(CGFloat.random(in: margin...length))
      self.init(
        frame1: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: offset),
        frame2: CGRect(x: frame.origin.x, y: frame.origin.y + offset, width: frame.size.width, height: frame.size.height - offset),
        line: MondrianDrawing.Line(
          start: CGPoint(x: frame.origin.x, y: frame.origin.y + offset),
          end: CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + offset)
        )
      )
    }
  }
}
