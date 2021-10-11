
import UIKit

class StoreItemContainerViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    weak var collectionViewController: StoreItemCollectionViewController?
    
    let searchController = UISearchController()
    let storeItemController = StoreItemController()

    var tableViewDataSource: UITableViewDiffableDataSource<String, StoreItem>!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
    
    var itemsSnapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
    
    var selectedSearchScope: SearchScope {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchScope = SearchScope.allCases[selectedIndex]
        
        return searchScope
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? StoreItemListTableViewController {
            configureTableViewDataSource(tableViewController.tableView)
        }
        
        if let collectionViewController = segue.destination as? StoreItemCollectionViewController {
            self.collectionViewController = collectionViewController
            collectionViewController.configureCollctionViewLayout(for: selectedSearchScope)
            configureCollectionViewDataSource(collectionViewController.collectionView)
        }
    }
    
    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = StoreItemTableViewDiffableDataSource(tableView: tableView, storeItemController: storeItemController)
    }
    
    func configureCollectionViewDataSource(_ collectionView: UICollectionView) {
        collectionViewDataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! ItemCollectionViewCell
            cell.configure(for: item, storeItemController: self.storeItemController)
            
            return cell
        })
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier, for: indexPath) as! StoreItemCollectionViewSectionHeader
            let title = self.itemsSnapshot.sectionIdentifiers[indexPath.section]
            headerView.setTitle(title)
            
            return headerView
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
        perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
    }
                
    @IBAction func switchContainerView(_ sender: UISegmentedControl) {
        tableContainerView.isHidden.toggle()
        collectionContainerView.isHidden.toggle()
    }
    
    @objc func fetchMatchingItems() {
        itemsSnapshot.deleteAllItems()
        
        // apply data source changes
        tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true, completion: nil)
        collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true, completion: nil)
        
        let searchTerm = searchController.searchBar.text ?? ""
        
        if !searchTerm.isEmpty {
            let searchScopes: [SearchScope]
            if selectedSearchScope == .all {
                searchScopes = [.movies, .music, .apps, .books]
            } else {
                searchScopes = [selectedSearchScope]
            }
            
            for searchScope in searchScopes {
                
                // set up query dictionary
                let query = [
                    "term": searchTerm,
                    "media": searchScope.mediaType,
                    "lang": "en_us",
                    "limit": "20"
                ]
                
                // use the item controller to fetch items
                storeItemController.fetchItems(matching: query) { (result) in
                    switch result {
                    case .success(let items):
                        // if successful, use the main queue to set self.items and reload the table view
                        DispatchQueue.main.async {
                            guard searchTerm == self.searchController.searchBar.text else {
                                return
                            }
                            
                            // apply data source changes
                            self.handleFetchedItems(items)
                        }
                    case .failure(let error):
                        // otherwise, print an error to the console
                        print(error)
                    }
                }
            }
        }
    }
    
    func handleFetchedItems(_ items: [StoreItem]) {
//        section이 없는 item들을 더하는 방법인데 필요한건 section이 있는 snapshot이므로 주석처리후에 만든 함수를 호출한다.
//        let currentSnapshotItems = itemsSnapshot.itemIdentifiers
//        var updatedSnapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
//        updatedSnapshot.appendSections(["Results"])
//        updatedSnapshot.appendItems(currentSnapshotItems + items)
//        itemsSnapshot = updatedSnapshot
        
        let currentSnapshotItems = itemsSnapshot.itemIdentifiers
        let updatedSnapshot = createSectionedSnapshot(from: currentSnapshotItems + items)
        itemsSnapshot = updatedSnapshot
        
        collectionViewController?.configureCollctionViewLayout(for: selectedSearchScope)
        
        tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true, completion: nil)
        collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true, completion: nil)
        
//        collectionViewController?.configureCollctionViewLayout(for: selectedSearchScope)
        // 책에는 apply하고 호출하라고 되있는데 이러면 category를 바꿀때 뭔가 이상하다.
        // 그래서 데이터 적용전에 호출해주는 것으로 바꾸면 괜찮은 것같다.
    }
    
    func createSectionedSnapshot(from items: [StoreItem]) -> NSDiffableDataSourceSnapshot<String, StoreItem> {
        let movies = items.filter { $0.kind == "feature-movie" }
        let music = items.filter { $0.kind == "song" || $0.kind == "album" }
        let apps = items.filter { $0.kind == "software" }
        let books = items.filter { $0.kind == "ebook" }
        
        let grouped: [(SearchScope, [StoreItem])] = [
            (.movies, movies),
            (.music, music),
            (.apps, apps),
            (.books, books)
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
        grouped.forEach { (scope, items) in
            if items.count > 0 {
                snapshot.appendSections([scope.title])
                snapshot.appendItems(items, toSection: scope.title)
            }
        }
        
        return snapshot
    }
}
