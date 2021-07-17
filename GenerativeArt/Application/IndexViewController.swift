import UIKit

class IndexViewController: UITableViewController {
  struct Section {
    let title: String
    let rows: [Row]
  }

  enum Row {
    case tiledDrawing(TiledDrawingType)
    case mondrian

    var title: String {
      switch self {
      case let .tiledDrawing(variation): return variation.title
      case .mondrian: return "Mondrian"
      }
    }
  }

  private let send: (Message) -> ()

  private let sections: [Section] = [
    Section(title: "Lines", rows: [
      .tiledDrawing(.diagonals),
      .tiledDrawing(.scribbles)
    ]),
    Section(title: "Shapes", rows: [
      .tiledDrawing(.triangles),
      .tiledDrawing(.quadrants),
      .tiledDrawing(.trianglesAndQuadrants),
      .tiledDrawing(.concentricShapes),
    ]),
    Section(title: "Painting Styles", rows: [
      .mondrian
    ])
  ]

  init(send: @escaping (Message) -> ()) {
    self.send = send
    super.init(style: .insetGrouped)

    title = "Generative Art"
    navigationItem.largeTitleDisplayMode = .always
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    sections[section].title
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sections[section].rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let rows = sections[indexPath.section].rows
    if indexPath.row < rows.count {
      cell.textLabel?.text = rows[indexPath.row].title
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rows = sections[indexPath.section].rows
    switch rows[indexPath.row] {
    case let .tiledDrawing(type): send(.showTiledDrawing(type))
    case .mondrian: send(.showMondrian)
    }
  }
}
