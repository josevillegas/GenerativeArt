import SwiftUI

struct MondrianDrawing {
  private let id = UUID() // This will make every drawing unique.
  private let colors: [Color] = [.red, .yellow, .blue]

  func paths(frame: CGRect) -> [GAPath] {
    let count = Int.random(in: 4...10)
    let (frames, lines) = reduce(frames: [frame], lines: [], count: count)
    let linePaths: [GAPath] = lines.map {
      let width = Bool.random() ? 7 : 8
      return GAPath(fillColor: nil, strokeColor: .black, lineWidth: CGFloat(width), commands: [
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

  private func colorPaths(frames: [CGRect]) -> [GAPath] {
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

  private func colorPath(_ frame: CGRect) -> GAPath {
    GAPath(fillColor: colors.randomElement(), strokeColor: nil, commands: [GAPath.Command.addRect(frame)])
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
    let width = frame.width
    let height = frame.height
    let x = frame.origin.x
    let y = frame.origin.y

    if Bool.random() {
      // Return two columns.
      let length = width - margin * 2
      guard length > margin else { return nil }

      let offset = margin + round(CGFloat.random(in: margin...length))
      self.init(
        frame1: CGRect(x: x, y: y, width: offset, height: height),
        frame2: CGRect(x: x + offset, y: y, width: width - offset, height: height),
        start: CGPoint(x: x + offset, y: y),
        end: CGPoint(x: x + offset, y: y + height)
      )
    } else {
      // Return two rows.
      let length = height - margin * 2
      guard length > margin else { return nil }

      let offset = margin + round(CGFloat.random(in: margin...length))
      self.init(
        frame1: CGRect(x: x, y: y, width: width, height: offset),
        frame2: CGRect(x: x, y: y + offset, width: width, height: height - offset),
        start: CGPoint(x: x, y: y + offset),
        end: CGPoint(x: x + width, y: y + offset)
      )
    }
  }

  init(frame1: CGRect, frame2: CGRect, start: CGPoint, end: CGPoint) {
    self.init(frame1: frame1, frame2: frame2, line: MondrianDrawing.Line(start: start, end: end))
  }
}
