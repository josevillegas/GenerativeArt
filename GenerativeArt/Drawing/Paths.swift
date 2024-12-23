import SwiftUI

extension GAPath {
  static func concentricShapes(_ frame: CGRect, colors: [Color]) -> [GAPath] {
    concentricShapePaths(frame: frame, colors: colors)
  }

  static func fillRect(_ frame: CGRect, color: Color) -> GAPath {
    GAPath(fillColor: color, strokeColor: nil, commands: [.addRect(frame)])
  }

  static func randomDiagonal(_ frame: CGRect, color: Color) -> GAPath {
    GAPath(fillColor: nil, strokeColor: color, commands: randomDiagonalCommands(frame: frame))
  }

  static func randomTriangle(_ frame: CGRect, color: Color) -> GAPath {
    GAPath(fillColor: color, strokeColor: nil, commands: randomTriangleCommands(frame: frame))
  }

  static func randomQuarterCircle(_ frame: CGRect, color: Color) -> GAPath {
    GAPath(fillColor: color, strokeColor: nil, commands: randomQuarterCircleCommands(frame: frame))
  }

  static func randomTrianglesAndQuarterCircles(_ frame: CGRect, color: Color) -> GAPath {
    switch Variation2.random() {
    case .a: randomTriangle(frame, color: color)
    case .b: randomQuarterCircle(frame, color: color)
    }
  }

  static func scribble(_ frame: CGRect, color: Color) -> GAPath {
    GAPath(fillColor: nil, strokeColor: color, commands: scribble(frame: frame))
  }
}

extension GAPath {
  static func randomDiagonalCommands(frame: CGRect) -> [GAPath.Command] {
    let origin = frame.origin
    let width = frame.size.width
    let height = frame.size.height

    let x: CGFloat
    let xOffset: CGFloat
    switch Variation2.random() {
    case .a:
      x = origin.x
      xOffset = width
    case .b:
      x = origin.x + width
      xOffset = -width
    }
    return  [
      .moveTo(x, origin.y),
      .addLineTo(x + xOffset, origin.y + height)
    ]
  }

  static func randomTriangleCommands(frame: CGRect) -> [GAPath.Command] {
    let origin = frame.origin
    let x = origin.x
    let y = origin.y
    let width = frame.size.width
    let height = frame.size.height

    return switch Variation4.random() {
    case .a:
      [
        .moveTo(origin),
        .addLineTo(x + width, y),
        .addLineTo(x + width, y + height)
      ]
    case .b:
      [
        .moveTo(x + width, y),
        .addLineTo(x + width, y + height),
        .addLineTo(x, y + height)
      ]
    case .c:
      [
        .moveTo(x + width, y + height),
        .addLineTo(x, y + height),
        .addLineTo(origin)
      ]
    case .d:
      [
        .moveTo(x, y + height),
        .addLineTo(origin),
        .addLineTo(x + width, y)
      ]
    }
  }

  static func randomQuarterCircleCommands(frame: CGRect) -> [GAPath.Command] {
    let origin = frame.origin
    let x = origin.x
    let y = origin.y
    let width = frame.size.width
    let height = frame.size.height

    switch Variation4.random() {
    case .a:
      return [
        .moveTo(origin),
        .addArc(GAPath.Arc(center: origin, radius: width, startAngle: 0, endAngle: 90, clockWise: true)),
        .close
      ]
    case .b:
      let center = CGPoint(x: x + width, y: y)
      return [
        .moveTo(center),
        .addArc(GAPath.Arc(center: center, radius: width, startAngle: 90, endAngle: 180, clockWise: true)),
        .close
      ]
    case .c:
      let center = CGPoint(x: x + width, y: y + height)
      return [
        .moveTo(center),
        .addArc(GAPath.Arc(center: center, radius: width, startAngle: 180, endAngle: 270, clockWise: true)),
        .close
      ]
    case .d:
      let center = CGPoint(x: x, y: y + height)
      return [
        .moveTo(center),
        .addArc(GAPath.Arc(center: center, radius: width, startAngle: 270, endAngle: 360, clockWise: true)),
        .close
      ]
    }
  }

  static func scribble(frame: CGRect) -> [GAPath.Command] {
    let controlFrame = frame.insetWithScale(2.8)
    let path = GAPath.BezierCurve(
      start: GAPath.BezierPoint(position: frame.randomPointInside(), control: controlFrame.randomPointInside()),
      end: GAPath.BezierPoint(position: frame.randomPointInside(), control: controlFrame.randomPointInside())
    )
    return [.addBezierCurve(path)]
  }

  /// Requires at least four colors.
  static func concentricShapePaths(frame: CGRect, colors: [Color]) -> [GAPath] {
    var colors = colors
    guard colors.count > 3 else { return [] }

    let color1 = colors.remove(at: Int.random(in: 0..<colors.count))
    let color2 = colors.remove(at: Int.random(in: 0..<colors.count))
    let color3 = colors.remove(at: Int.random(in: 0..<colors.count))
    let color4 = colors[Int.random(in: 0..<colors.count)]

    let frame2 = frame.insetWithScale(0.8)
    let frame3 = frame.insetWithScale(0.55)
    let frame4 = frame.insetWithScale(0.3)
    let cornerRadius2 = min(frame2.width, frame2.height) * 0.25
    let cornerRadius3 = min(frame3.width, frame3.height) * 0.32

    return [
      GAPath(fillColor: color1, strokeColor: nil, commands: [.addRect(frame)]),
      GAPath(fillColor: color2, strokeColor: nil, commands: [.addShape(.roundedRect(frame2, radius: cornerRadius2))]),
      GAPath(fillColor: color3, strokeColor: nil, commands: [.addShape(.roundedRect(frame3, radius: cornerRadius3))]),
      GAPath(fillColor: color4, strokeColor: nil, commands: [.addShape(.oval(frame4))])
    ]
  }
}

extension CGRect {
  func insetWithScale(_ scale: CGFloat) -> CGRect {
    insetBy(
      dx: (width - width * scale) / 2,
      dy: (height - height * scale) / 2
    )
  }

  func randomPointInside() -> CGPoint {
    CGPoint(
      x: CGFloat.random(in: origin.x...(origin.x + size.width)),
      y: CGFloat.random(in: origin.y...(origin.y + size.height))
    )
  }
}
