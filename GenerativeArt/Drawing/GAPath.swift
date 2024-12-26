import SwiftUI

struct GAPath: Equatable {
  let fillColor: Color?
  let strokeColor: Color?
  let lineWidth: CGFloat
  let commands: [Command]
}

extension GAPath {
  enum Command: Equatable {
    case moveTo(CGPoint)
    case addLineTo(CGPoint)
    case addArc(Arc)
    case addBezierCurve(BezierCurve)
    case addShape(Shape)
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

  enum Shape: Equatable {
    case oval(CGRect)
    case rect(CGRect)
    case roundedRect(CGRect, radius: CGFloat)
  }

  // `startAngle` and `endAngle` are in degrees.
  struct Arc: Equatable {
    let center: CGPoint
    let radius: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat
  }

  struct BezierPoint: Equatable {
    let position: CGPoint
    let control: CGPoint
  }

  struct BezierCurve: Equatable {
    let start: BezierPoint
    let end: BezierPoint
  }
}

extension GAPath {
  func path() -> Path {
    Path { path in
      for command in commands {
        switch command {
        case let .moveTo(point): path.move(to: point)
        case let .addLineTo(point): path.addLine(to: point)
        case let .addArc(arc):
          path.addArc(
            center: arc.center,
            radius: arc.radius,
            startAngle: .radians(arc.startAngle * CGFloat.pi * 2.0 / 360),
            endAngle: .radians(arc.endAngle * CGFloat.pi * 2.0 / 360),
            clockwise: false
          )
        case let .addBezierCurve(curve):
          path.move(to: curve.start.position)
          path.addCurve(to: curve.end.position, control1: curve.start.control, control2: curve.end.control)
        case let .addShape(shape):
          switch shape {
          case let .oval(frame): path.addEllipse(in: frame)
          case let .rect(frame): path.addRect(frame)
          case let .roundedRect(frame, radius):
            path.addRoundedRect(
              in: frame,
              cornerRadii: RectangleCornerRadii(topLeading: radius, bottomLeading: radius, bottomTrailing: radius, topTrailing: radius) ,
              style: .circular
            )
          }
        case .close: path.closeSubpath()
        }
      }
    }
  }
}
