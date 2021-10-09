// command shift 영어 o : open quickly

import UIKit

class ViewController: UIViewController {
        
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }

    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        // 보여주기 위해서는 cell을 collectionView에 등록해야하고 datasource가 셀을 반환하도록 해야한다.
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardAppCollectionViewCell.self, forCellWithReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        // dataSource가 생성되기 전에 등록해야한다.
        
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.header,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.topLine,
                                withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine,
                                withReuseIdentifier: LineView.reuseIdentifier)
        
        
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
//        fatalError("TODO: Create Layout") 원래 코드.
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // 이 UICollectionViewCompositionalLayout의 initializer는 sectionProvider를 사용한다.
            // sectionProvider는 sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment를 매개변수로 받고
            // NSCollectionLayoutSection?을 반환하는 클로져이다.
            
            // headerItem 만드는 코드 standard와 categories 케이스에서 같이 사용되므로 switch문 바깥으로 뺐다. 따로 메소드로 만들어도 된다고 책에서 알려주었다.
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            
            // lineItem 만드는 코드.
            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale
            let lineItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .absolute(lineItemHeight)
            )
            let topLineItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: SupplementaryViewKind.topLine, alignment: .top)
            
            let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: SupplementaryViewKind.bottomLine, alignment: .bottom)
            
            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            
            headerItem.contentInsets = supplementaryItemContentInsets
            topLineItem.contentInsets = supplementaryItemContentInsets
            bottomLineItem.contentInsets = supplementaryItemContentInsets
            
            let section = self.sections[sectionIndex]
            switch section {
            case .promoted:
                // MARK: Promoted Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1) // 이런식으로 정사각형을 표현할 수 있다.
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(300)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                // 여기서 centered는 page가 화면에 가운데 정렬하도록 설정한다.
                // .groupPaging을 사용한다면 page가 왼쪽으로 정렬된다.
                // 이외에도 다른 방법이 있다. 도큐멘트 확인 바람.
                section.boundarySupplementaryItems = [topLineItem, bottomLineItem]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)
                
                return section
                
            case .standard:
                // MARK: Standard Section Layout
                let itemSzie = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSzie)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 4,
                    bottom: 0,
                    trailing: 4
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(250)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 29, trailing: 0)
                
                return section
            case .categories:
                // MARK: Categories Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width // 이용할 수 있는 너비
                let groupWidth = availableLayoutWidth * 0.92    // 위에 두 섹션이 사용한 .fractionalWidth에 사용한 값인 0.92를 곱해줘서 크기를 맞춤
                let remainingWidth = availableLayoutWidth - groupWidth  // 이용가능한 전체 크기에서 위에 두 섹션의 크기값을 뺀다 그러면 남는 부분의 값을 알 수 있다.
                let halfOfRemainingWidth = remainingWidth / 2 // 남는 부분이 양쪽으로 배치되어야 하므로 2로 나눈다.
                let nonCategorySectionItemInset = CGFloat(4)    // 위에 두 섹션에 더한 spacing 값(4).
                let itemLeadingAndTrailingInset = halfOfRemainingWidth + nonCategorySectionItemInset
                // 남는 부분을 2로 나눈 값과 다른 섹션에서 사용한 spacing 값을 더해주어 실제 사용할 inset값을 구한다.
                
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: itemLeadingAndTrailingInset,
                    bottom: 0,
                    trailing: itemLeadingAndTrailingInset
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            }
        }
        return layout
    }
    
    func configureDataSource() {
//        fatalError("TODO: Create Data Source") 원래 코드.
        
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) in
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier, for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
                
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier, for: indexPath) as! StandardAppCollectionViewCell
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(item.app!, hideBottomLine: isThirdItem)
                
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.configureCell(item.category!, hideBottomLine: isLastItem)
                
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case .promoted:
                    return nil
                case .standard(let name):
                    sectionName = name
                case .categories:
                    sectionName = "Top Categories"
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.setTitle(sectionName)
                
                return headerView
            case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                
                return lineView
            default:
                return nil
            }
        }
        
        // MARK: Snapshot Definition
        // "// MARK:" 이 코멘트는 jump bar와 minimap에서 확인할 수 있게하고 빠르게 점프할 수 있게 한다.
        // Jump bar는 탭창 밑에 클릭해서 넘어가는 부분이고 minimap은 오른쪽에 미니맵이다.
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        
        let popularSection = Section.standard("Popular this week")
        let essentialSection = Section.standard("Essential picks")
        let categoriesSection = Section.categories
        
        snapshot.appendSections([popularSection, essentialSection, categoriesSection])
        snapshot.appendItems(Item.popularApps, toSection: popularSection)
        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
        snapshot.appendItems(Item.categories, toSection: categoriesSection)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}

