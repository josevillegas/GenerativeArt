import UIKit

struct GAPath {
  let fillColor: UIColor?
  let strokeColor: UIColor?
  let lineWidth: CGFloat
  let commands: [Command]

  init(fillColor: UIColor? = nil, strokeColor: UIColor? = nil, lineWidth: CGFloat = 1, commands: [Command]) {
    self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.lineWidth = lineWidth
    self.commands = commands
  }
}

extension GAPath {
  enum Command {
    case moveTo(CGPoint)
    case addLineTo(CGPoint)
    case addArc(Arc)
    case addBezierCurve(BezierCurve)
    case addShape(GAShape)
    case close

    static func moveTo(_ x: CGFloat, _ y: CGFloat) -> Command {
      .moveTo(CGPoint(x: x, y: y))
    }

    static func addLineTo(_ x: CGFloat, _ y: CGFloat) -> Command {
      .addLineTo(CGPoint(x: x, y: y))
    }

    static func addRect(_ rect: CGRect) -> Command {
      .addShape(.rect(rect))
    }
  }

  enum GAShape {
    case oval(CGRect)
    case rect(CGRect)
    case roundedRect(CGRect, radius: CGFloat)
  }

  // `startAngle` and `endAngle` are in degrees.
  struct Arc {
    let center: CGPoint
    let radius: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat
    let clockWise: Bool
  }

  struct BezierPoint {
    let position: CGPoint
    let control: CGPoint
  }

  struct BezierCurve {
    let start: BezierPoint
    let end: BezierPoint
  }
}

extension GAPath {
  func draw() {
    let bezierPath = UIBezierPath()
    for command in commands {
      switch command {
      case let .moveTo(point): bezierPath.move(to: point)
      case let .addLineTo(point): bezierPath.addLine(to: point)
      case let .addShape(shape):
        switch shape {
        case let .oval(frame): bezierPath.append(UIBezierPath(ovalIn: frame))
        case let .rect(rect): bezierPath.append(UIBezierPath(rect: rect))
        case let .roundedRect(frame, radius): bezierPath.append(UIBezierPath(roundedRect: frame, cornerRadius: radius))
        }
      case let .addArc(arc):
        bezierPath.addArc(
          withCenter: arc.center,
          radius: arc.radius,
          startAngle: arc.startAngle * CGFloat.pi * 2 / 360,
          endAngle: arc.endAngle * CGFloat.pi * 2 / 360,
          clockwise: arc.clockWise
        )
      case let .addBezierCurve(curve):
        bezierPath.move(to: curve.start.position)
        bezierPath.addCurve(to: curve.end.position, controlPoint1: curve.start.control, controlPoint2: curve.end.control)
      case .close: bezierPath.close()
      }
    }
    if let color = fillColor {
      color.set()
      bezierPath.fill()
    }
    if let color = strokeColor {
      color.set()
      bezierPath.lineWidth = lineWidth
      bezierPath.stroke()
    }
  }
}

extension Array where Element == GAPath {
  func draw() {
    forEach { $0.draw() }
  }
}
