//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    let category: String
    var menuItems = [MenuItem]()
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchMenuItems(forCategory: category) { (result) in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .menu(category: category))
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
//        cell.detailTextLabel?.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                // 잘못된 이미지를 재활용된 셀에 삽입하고 싶지 않으므로 셀이 현재 위치한 인덱스 경로를 확인하십시오.
                // 변경된 경우 이미지 보기 설정을 건너뛸 수 있습니다.
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()   // 이미지 뷰의 크기가 이전에 0이었을 수 있으므로 셀이 레이아웃을 업데이트할 필요가 있음을 알리는 것입니다.
            }
        }
    }
}
