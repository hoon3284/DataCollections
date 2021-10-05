// EmojiDictionary

import UIKit

private let reuseIdentifier = "Item"
private let headerIdentifier = "Header"
private let headerKind = "header"
private let columnReuseIdentifier = "ColumnItem"

class EmojiCollectionViewController: UICollectionViewController {
    @IBOutlet var layoutButton: UIBarButtonItem!
    
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ]
    
    var sections: [Section] = []
    
    enum Layout {
        case grid
        case column
    }
    
    var activeLayout: Layout = .grid {
        didSet {
            if let layout = layout[activeLayout] {
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                // layout을 바꾸기전에 reload해주는 것은 아주 중요하다.
                // 이 작업을 해주어야 layout을 바꾸었을때 smooth transition이 가능하기 때문이다.
                
                collectionView.setCollectionViewLayout(layout, animated: true) { (_) in
                    switch self.activeLayout {
                    case .grid:
                        self.layoutButton.image = UIImage(systemName: "rectangle.grid.1x2")
                    case .column:
                        self.layoutButton.image = UIImage(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
    
    var layout: [Layout: UICollectionViewLayout] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(EmojiCollectionViewHeader.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: headerIdentifier)
        
        layout[.grid] = generateGridLayout()
        layout[.column] = generateColumnLayout()
        
        if let layout = layout[activeLayout] {
            collectionView.collectionViewLayout = layout
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSections()
        collectionView.reloadData()
    }
    
    func generateColumnLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 10
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            ),
            subitem: item,
            count: 1
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 0,
            trailing: padding
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = padding
        
        section.contentInsets = NSDirectionalEdgeInsets (
            top: padding,
            leading: 0,
            bottom: padding,
            trailing: 0
        )
        
        section.boundarySupplementaryItems = [generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateGridLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 20
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4)),
            subitem: item,
            count: 2
        )
        
        group.interItemSpacing = .fixed(padding)
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 0,
            trailing: padding
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = padding
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: padding,
            leading: 0,
            bottom: padding,
            trailing: 0
        )
        
        section.boundarySupplementaryItems = [generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40)),
            elementKind: headerKind,
            alignment: .top
        )
        
        header.pinToVisibleBounds = true
        
        return header
    }
    
    func updateSections() {
        sections.removeAll()
        
        let grouped = Dictionary(grouping: emojis, by: { $0.sectionTitle })
        
        for (title, emojis) in grouped.sorted(by: { $0.0 < $1.0 }) {
            sections.append(
                Section(
                    title: title,
                    emojis: emojis.sorted(by: { $0.name < $1.name })
                )
            )
        }
    }
    
    @IBAction func switchLayouts(sender: UIBarButtonItem) {
        switch activeLayout {
        case .grid:
            activeLayout = .column
        case .column:
            activeLayout = .grid
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return emojis.count
//        } else {
//            return 0
//        }
        return sections[section].emojis.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = activeLayout == .grid ? reuseIdentifier : columnReuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! EmojiCollectionViewCell
    
        //Step 2: Fetch model object to display
        let emoji = emojis[indexPath.item]

        //Step 3: Configure cell
        cell.update(with: emoji)

        //Step 4: Return cell
        return cell
    }
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            // Editing Emoji
//            let emojiToEdit = emojis[indexPath.row]
            let emojiToEdit = sections[indexPath.section].emojis[indexPath.item]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
   
    func indexPath(for emoji: Emoji) -> IndexPath? {
        // emoji로 indexPath 위치를 알 수 있는 메소드.
        if let sectionIndex = sections.firstIndex(where: { $0.title == emoji.sectionTitle }),
           let index = sections[sectionIndex].emojis.firstIndex(where: { $0 == emoji }) {
            return IndexPath(item: index, section: sectionIndex)
        }
        
        return nil
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }
        
        if let path = collectionView.indexPathsForSelectedItems?.first,
           let i = emojis.firstIndex(where: { $0 == emoji }) {
            emojis[i] = emoji
            updateSections()
            
            collectionView.reloadItems(at: [path])
        } else {
            emojis.append(emoji)
            updateSections()
            
            if let newIndexPath = indexPath(for: emoji) {
                collectionView.insertItems(at: [newIndexPath])
            }
        }
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            let delete = UIAction(title: "Delete") { (action) in
                self.deleteEmoji(at: indexPath)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // this method is called  when the collection view asks for a header.
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! EmojiCollectionViewHeader
        
        header.titleLabel.text = sections[indexPath.section].title
        
        return header
    }

    func deleteEmoji(at indexPath: IndexPath) {
        let emoji = sections[indexPath.section].emojis[indexPath.item]
        guard let index = emojis.firstIndex(where: { $0 == emoji }) else { return }
        
        emojis.remove(at: index)
        sections[indexPath.section].emojis.remove(at: indexPath.item)
        
        collectionView.deleteItems(at: [indexPath])
    }
    
    // IndexPath에서 row와 item은 기능은 동일하다고 한다.
    // 그런데 코드의 가독성을 위해서 tableView에서는 row를, collectionView에서는 item을 사용하는게
    // 좋다고 하지만 틀릴 수도 있다 나중에 더 찾아보자.
}
