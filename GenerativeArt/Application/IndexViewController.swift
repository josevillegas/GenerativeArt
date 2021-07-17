import UIKit

struct Index {
  let sections: [Section]
}

extension Index {
  struct Section {
    let title: String
    let rows: [Row]
  }

  enum Row {
    case tiledDrawing(TiledDrawingType)
    case paintingStyle(PaintingStyle)

    var title: String {
      switch self {
      case let .tiledDrawing(type): return type.title
      case let .paintingStyle(style): return style.title
      }
    }
  }
}

class IndexViewController: UITableViewController {
  private let index: Index
  private let send: (Message) -> ()

  init(index: Index, send: @escaping (Message) -> ()) {
    self.index = index
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
    index.sections.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    index.sections[section].title
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    index.sections[section].rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let rows = index.sections[indexPath.section].rows
    if indexPath.row < rows.count {
      cell.textLabel?.text = rows[indexPath.row].title
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch index.sections[indexPath.section].rows[indexPath.row] {
    case let .tiledDrawing(type): send(.showDrawing(.tile(type)))
    case let .paintingStyle(style): send(.showDrawing(.paintingStyle(style)))
    }
  }
}
