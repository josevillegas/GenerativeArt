import UIKit

struct Index {
  let sections: [Section]
}

extension Index {
  struct Section: Hashable {
    let title: String
    let rows: [Row]
  }

  enum Row: Hashable {
    case drawing(DrawingType)

    var title: String {
      switch self {
      case let .drawing(type): return type.title
      }
    }
  }
}

class IndexViewController: UICollectionViewController {
  typealias DataSource = UICollectionViewDiffableDataSource<String, Index.Row>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>

  private let index: Index
  private let send: (Message) -> ()
  private lazy var dataSource: DataSource = { makeDataSource() }()

  init(index: Index, appearance: UICollectionLayoutListConfiguration.Appearance, send: @escaping (Message) -> ()) {
    self.index = index
    self.send = send
    super.init(collectionViewLayout: .indexLayout(appearance: .insetGrouped))

    title = "Generative Art"
    navigationItem.largeTitleDisplayMode = .always
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let sections = index.sections.map(\.title)
    var snapshot = NSDiffableDataSourceSnapshot<String, Index.Row>()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot)

    for section in index.sections {
      var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Index.Row>()
      sectionSnapshot.append(section.rows)
      dataSource.apply(sectionSnapshot, to: section.title, animatingDifferences: false)
    }
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch index.sections[indexPath.section].rows[indexPath.row] {
    case let .drawing(type): send(.showDrawing(type))
    }
  }

  func makeDataSource() -> DataSource {
    let registration = UICollectionView.CellRegistration<IndexCell, Index.Row> { cell, _, item in
      cell.label.text = item.title
    }
    let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
    }

    let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] view, _, indexPath in
      guard let self = self else { return }
      let title = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
      var configuration = view.defaultContentConfiguration()
      configuration.text = title
      view.contentConfiguration = configuration
    }
    dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
      self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }

    return dataSource
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
  static func indexLayout(appearance: UICollectionLayoutListConfiguration.Appearance) -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
      .indexLayoutSection(environment: environment, appearance: appearance)
    }
  }
}

extension NSCollectionLayoutSection {
  static func indexLayoutSection(
    environment: NSCollectionLayoutEnvironment,
    appearance: UICollectionLayoutListConfiguration.Appearance
  ) -> NSCollectionLayoutSection {
    var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
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
