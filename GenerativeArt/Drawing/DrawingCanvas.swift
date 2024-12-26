import SwiftUI

struct DrawingCanvas: View {
  let paths: [GAPath]

  var body: some View {
    Canvas { context, size in
      for gaPath in paths {
        let path = gaPath.path()
        if let fillColor = gaPath.fillColor {
          context.fill(path, with: .color(fillColor), style: FillStyle())
        }
        if let strokeColor = gaPath.strokeColor {
          context.stroke(path, with: .color(strokeColor), style: StrokeStyle(lineWidth: gaPath.lineWidth))
        }
      }
    }
    .background(.white, ignoresSafeAreaEdges: Edge.Set())
  }
}
