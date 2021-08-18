//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by wickedRun on 2021/08/13.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis: [Emoji] = [] {
        didSet {
            Emoji.saveToFile(emojis: emojis)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // description이 길때 text가 잘리는것을 방지하기위해.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        let loadEmojis = Emoji.loadFromFile()
        if loadEmojis.count != 0 {
            emojis = loadEmojis
        } else {
            emojis = Emoji.sampleEmojis()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // view가 나타났을때 호출되는 이 메서드에서 reloadData()를 호출하여 강제로 data를 Refresh한다.
    }

    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // Editing Emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji
        else {
            // 선택된 상태로 + 버튼을 누르고 이모지를 추가할 경우 밑에서 let selectedIndexPath에서 nil이 아니고 IndexPath를 받게 되어서 추가가 아니라 수정이 되기 때문에
            // 가드문에서 선택을 해제 해주었음.
            if let selected = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selected, animated: false)
            }
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 섹션이 몇개인지.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 섹션에 몇 열인지.
        return emojis.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Step 1: Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell // customCell로 캐스팅해준다.
        // Step 2: Fetch model object to display
        let emoji = emojis[indexPath.row]
        
        // Step 3: Configure cell
        cell.update(with: emoji)
        cell.showsReorderControl = true // reorder 하기위해서 필요함.
        
        // Step 4: Return cell
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // This method is used to respond to user interaction with the accessory view.
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // DataSource method
        let emoji = emojis.remove(at: fromIndexPath.row)
        emojis.insert(emoji, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

}
