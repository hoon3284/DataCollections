//
//  SelectRoomTypeTableViewController.swift
//  HotelManzana
//
//  Created by wickedRun on 2021/08/22.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: class { // 여기서 나오는 경고 메세지는 https://zeddios.tistory.com/508 요약하면 class와 AnyObject는 같다.
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?

    var roomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "$ \(roomType.price)"
        
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomType = RoomType.all[indexPath.row]
        self.roomType = roomType
        delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
        // delegate 이해
        // 1. The user taps a cell to make a selection, triggering didSelectRow.
        // 2. The tableView(_:didSelectRowAt:) method calls the delegate method selectRoomTypeTableView(_:didSelect:), using two things: the receiver stored in the delegate property (your AddRegistrationTableViewController instance) and the index path to the selected room type (which will be used as the parameter of the selectRoomTypeTableViewController(_:didSelect:) method).
        // 3. In the AddRegistrationTableViewController, the selectRoomTypeTableViewController(_:didSelect:) method provides access to the room type parameter and updates the AddRegistrationTableViewController property that's holding the selected room type. This is the implementation of the method called in step 2.
        tableView.reloadData() // reload하는 이유는 셀을 생성하는 함수를 다시 호출하기 위함이다.
    }
}
