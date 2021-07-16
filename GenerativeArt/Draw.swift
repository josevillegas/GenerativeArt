import UIKit

struct Draw {
  static func paths(_ paths: [Path]) {
    for item in paths {
      path(item)
    }
  }

  static func path(_ path: Path) {
    let bezierPath = UIBezierPath()
    for command in path.commands {
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
    if let color = path.fillColor {
      color.set()
      bezierPath.fill()
    }
    if let color = path.strokeColor {
      color.set()
      bezierPath.lineWidth = path.lineWidth
      bezierPath.stroke()
    }
  }
}
