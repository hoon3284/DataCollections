//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by wickedRun on 2021/08/20.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    var registration: Registration?
 
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        return dateFormatter
    }()
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
 
    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
    var roomType: RoomType?
    @IBOutlet var doneBarbuttonItem: UIBarButtonItem!
    
    init?(coder: NSCoder, registration: Registration?, roomType: RoomType?) {
        self.registration = registration
        self.roomType = roomType
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let registration = registration {
            firstNameTextField.text = registration.firstName
            lastNameTextField.text = registration.lastName
            emailTextField.text = registration.emailAddress
            checkInDatePicker.date = registration.checkInDate
            checkOutDatePicker.date = registration.checkOutDate
            numberOfAdultsStepper.value = Double(registration.numberOfAdults)
            numberOfChildrenStepper.value = Double(registration.numberOfChildren)
        } else {
            let midnightToday = Calendar.current.startOfDay(for: Date())
            checkInDatePicker.minimumDate = midnightToday
            checkInDatePicker.date = midnightToday
        }
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateNumberOfNightsViews()
        updateRoomTypeChargeViews()
        updateWiFiChargeViews()
        updateTotalChargeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.roomType != nil {
            doneBarbuttonItem.isEnabled = true
        } else {
            doneBarbuttonItem.isEnabled = false
        }
    }
    
    // doneButtonTapped method 삭제.
 
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1,  to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        updateNumberOfNightsViews()
        updateWiFiChargeViews()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            // check-in label selected, check-out picker is not visible, toggle check-in picker
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
            // check-out label selected, check-in picker is not visible, toggle check-out picker
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
            // either label was selected, previous conditions failed meaning at least one pikcer is visible, toggle both
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        // implemented later
        updateWiFiChargeViews()
        updateTotalChargeView()
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateRoomTypeChargeViews()
        updateTotalChargeView()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "doneUnwind" else { return }
        guard let roomType = roomType else { return }
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        registration = Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
    }
    
    // Challenge
    @IBOutlet var numberOfNightsLabel: UILabel!
    @IBOutlet var numberOfNightsDetailLabel: UILabel!
    var distance: Int {
        let distance = checkInDatePicker.date.distance(to: checkOutDatePicker.date) / 86400.0
        return Int(distance)
    }
    
    @IBOutlet var roomTypeChargeLabel: UILabel!
    @IBOutlet var roomTypeChargeDetailLabel: UILabel!
    var roomTypeCharge: Int {
        guard let roomtype = roomType else { return 0}
        return roomtype.price * distance
    }
    
    @IBOutlet var wifiChargeLabel: UILabel!
    @IBOutlet var wifiChargeDetailLabel: UILabel!
    let wifiPrice = 10
    
    @IBOutlet var totalChargeLabel: UILabel!
    
    func updateNumberOfNightsViews() {
        numberOfNightsLabel.text = "\(distance)"
        numberOfNightsDetailLabel.text = "\(dateFormatter.string(from: checkInDatePicker.date)) - \(dateFormatter.string(from: checkOutDatePicker.date))"
    }
    
    func updateRoomTypeChargeViews() {
        guard let roomtype = roomType else {
            roomTypeChargeLabel.text = "$ 0"
            roomTypeChargeDetailLabel.text = "Not Set"
            return
        }
        roomTypeChargeLabel.text = "$ \(roomTypeCharge)"
        roomTypeChargeDetailLabel.text = "\(roomtype.name) @ $\(roomtype.price)/night"
    }
    
    func updateWiFiChargeViews() {
        wifiChargeLabel.text = wifiSwitch.isOn ? "$ \(wifiPrice * distance)" : "$ 0"
        wifiChargeDetailLabel.text = wifiSwitch.isOn ? "yes" : "no"
    }
    
    func updateTotalChargeView() {
        guard roomType != nil else {
            totalChargeLabel.text = "$ 0"
            return
        }
        totalChargeLabel.text = wifiSwitch.isOn ? "$ \((wifiPrice * distance) + roomTypeCharge)" : "$ \(roomTypeCharge)"
    }
}
