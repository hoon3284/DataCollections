import UIKit

private let reuseIdentifier = "Cell"

private let items = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
    "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
    "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
    "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York",
    "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming"
]


class BasicCollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController()
    lazy var filteredItems: [String] = items
    var itemsByInitialLetter: [String.Element: Array<String>] {
        filteredItems.reduce([:]) { existing, element in
            return existing.merging([element.first!:[element]]) { old, new in
                return old + new
            }
        }
    }
    var initialLetters: [Dictionary<String.Element,Array<String>>.Keys.Element] {
        itemsByInitialLetter.keys.sorted()
    }
    // Diffable DataSource
    var dataSource: UICollectionViewDiffableDataSource<Character,String>!
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Character, String> {
        var snapshot = NSDiffableDataSourceSnapshot<Character, String>()
        
        for section in initialLetters {
            snapshot.appendSections([section])
            snapshot.appendItems(itemsByInitialLetter[section]!)
        }
        
        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        navigationItem.searchController = searchController // navigationAPI의 쉽게 search controller를 달수있는 hook
        searchController.obscuresBackgroundDuringPresentation = false // true일 때 search bar를 tap하자마자 뒷 배경을 불투명하게 만든다.
        searchController.searchResultsUpdater = self // 결과를 업데이트하는걸 이 클래스로 설정
        // 그로인해 UISearchResultsUpdating protocol을 conform해야한다. 그래서 밑에 있는 updateSearchResults를 구현해야한다.
        // searchResultsUpdater는 실제 필터링 로직을 다루는 delegate임.
        createDataSource()
    }

    func updateSearchResults(for searchController: UISearchController) {
        // 이 메소드는 아이템 프로퍼티를 필터하고 사용자에게 맞는 결과를 보여주는 로직을 구현하는 메소드.
        if let searchString = searchController.searchBar.text, searchString.isEmpty == false {
            filteredItems = items.filter { (item) -> Bool in
                item.localizedCaseInsensitiveContains(searchString)
            }
        } else {
            filteredItems = items
        }
        
//        collectionView.reloadData()
        // 이 함수는 밑에 적어 두었듯이 reloadData와 비슷한 메소드
        dataSource.apply(filteredItemsSnapshot, animatingDifferences: true) // animation이가능하도록 하려면 이 animatingDifferences 매개변수를 사용하는 메소드를 사용하여야함
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let spacing: CGFloat = 10.0

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        group.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // 밑에 createDataSource로 initialize해주면 dataSource가 생성되면 밑에 UICollectionViewDataSource 메소드들을 사용하지 않아도 된다.
    // MARK: - UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return filteredItems.count
//    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
//
//        cell.label.text = filteredItems[indexPath.item]
//
//        return cell
//    }

    // MARK: - UICollectionViewDelegate

    // TBD
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Character,String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
            cell.label.text = item
            return cell
        })
    
        
//        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! BasicHeaderView
//            header.label.text = String(self.initialLetters[indexPath.section])
//            return header
//        }
        
        dataSource.apply(filteredItemsSnapshot) // dataSource에 값들을 filteredItemsSnapshot으로 적용, 약간 reloadData같은 느낌.
    }
}
