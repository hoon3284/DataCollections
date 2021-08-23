//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by wickedRun on 2021/08/23.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
    func employeeTypeTableViewController(_ viewContoller: EmployeeTypeTableViewController, didSelect: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {
    var delegate: EmployeeTypeTableViewControllerDelegate?
    var employeeType: EmployeeType?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeTypeCell", for: indexPath)
        let type = EmployeeType.allCases[indexPath.row]
        cell.textLabel?.text = type.description
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = EmployeeType.allCases[indexPath.row]
        delegate?.employeeTypeTableViewController(self, didSelect: type)
        employeeType = type
        tableView.reloadData()
    }
}
