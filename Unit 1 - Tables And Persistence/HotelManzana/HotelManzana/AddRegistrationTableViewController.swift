//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by wickedRun on 2021/08/20.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    var dateFormatter: DateFormatter = {
        // 이렇게 클로져로 호출하면 AddRegistrationTableViewController의 인스턴스가 생성되었을 때 dateFormatter가 available일것을 보증한다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        return dateFormatter
    }()
//    책에서는 이런식으로 구성하면 안된다고 했고, 반드시 그런건 아니지만 viewDidLoad()에서 인스턴스 변수를 설정하는 것과 옵셔널 값을 처리하는 것보다 클로저로 구성하는 것이 좋은 방법이 될 수 있다.
//    var dateFormatter = DateFormatter()
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateViews()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1,  to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
}
