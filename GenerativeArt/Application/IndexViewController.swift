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
    case drawing(DrawingType)

    var title: String {
      switch self {
      case let .drawing(type): return type.title
      }
    }
  }
}

class IndexViewController: UICollectionViewController {
  private let index: Index
  private let send: (Message) -> ()

  init(index: Index, send: @escaping (Message) -> ()) {
    self.index = index
    self.send = send
    super.init(collectionViewLayout: .indexLayout())

    title = "Generative Art"
    navigationItem.largeTitleDisplayMode = .always
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(IndexCell.self, forCellWithReuseIdentifier: "Cell")
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    index.sections.count
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    index.sections[section].rows.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    let rows = index.sections[indexPath.section].rows
    if let cell = cell as? IndexCell, indexPath.row < rows.count {
      cell.label.text = rows[indexPath.row].title
    }
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch index.sections[indexPath.section].rows[indexPath.row] {
    case let .drawing(type): send(.showDrawing(type))
    }
  }
}

final class IndexCell: UICollectionViewCell {
  let label = UILabel()

  static let insetMargin: CGFloat = 18

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    contentView.addSubview(label)
    label.addEdgeConstraints(to: contentView, insets: UIEdgeInsets(top: 12, left: Self.insetMargin, bottom: 12, right: Self.insetMargin))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UICollectionViewLayout {
  static func indexLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
      .indexLayoutSection(environment: environment)
    }
  }
}

extension NSCollectionLayoutSection {
  static func indexLayoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    configuration.separatorConfiguration
      .bottomSeparatorInsets = NSDirectionalEdgeInsets(top: 0, leading: IndexCell.insetMargin, bottom: 0, trailing: 0)
    let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }
}
