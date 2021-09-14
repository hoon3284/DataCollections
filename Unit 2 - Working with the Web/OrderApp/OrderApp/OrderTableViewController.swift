//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import UIKit

class OrderTableViewController: UITableViewController {
//    let order = MenuController.shared.order
    var minutesToPrepareOrder = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem   // swipe 삭제를 모를 수도 있기 때문에 edit버튼도 달아준다.
        
        // viewDidLoad에서 Observer를 달았다.
        // 약간 이 옵저버가 알림을 체크하고 알림이 오면 reloadData 호출. 하는 그런 느낌.
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .order)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 모든 cell을 선택할 수 있기 때문에 그냥 return true, 따로 조작할 필요가 있으면 이쪽에 작성.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 이 함수를 써줘야 swipe로 삭제 가능이지만 이 함수는 editStyle에 대한 처리를 하는 함수가 기본 기능.
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }

    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        let formattedTotal = MenuItem.priceFormatter.string(from: NSNumber(value: orderTotal)) ?? "\(orderTotal)"
        
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to sumbit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIds) { (result) in
            switch result {
            case .success(let minutesToPrepare):
                DispatchQueue.main.async {
                    self.minutesToPrepareOrder = minutesToPrepare
                    self.performSegue(withIdentifier: "confirmOrder", sender: nil)
                }
            case .failure(let error):
                self.displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        
        configure(cell, forItemAt: indexPath)

        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
//        cell.detailTextLabel?.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
}
