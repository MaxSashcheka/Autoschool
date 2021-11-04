//
//  CreateInstruktorViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateInstruсtorViewController: UIViewController {
    
    var cars = [Car]()
    var driverLicenses = [DriverLisence]()

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    
    @IBOutlet weak var drivingExperienceTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var carsTableView: UITableView!
    var selectedCarIndex = 0
    
    @IBOutlet weak var driverLicensesTableView: UITableView!
    var selectedDriverLicenseIndex = 0
    
    @IBOutlet weak var carsSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var carsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var driverLicenseTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var driverLicenseSuperViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить инструктора"
        view.backgroundColor = UIColor.viewBackground
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        drivingExperienceTextField.delegate = self
        passportNumberTextField.delegate = self
        phoneNumberTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        setupBarButtonItems()
        configureCarsTableView()
        configureDriverLicenseTableView()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchCars { fetchedCars in
            self.cars = fetchedCars
            self.carsTableView.reloadData()
            self.carsTableViewHeight.constant = CGFloat(self.cars.count) * self.carsTableView.rowHeight + 10
            self.carsSuperViewHeight.constant = self.carsTableViewHeight.constant + 30
        }
        NetworkManager.shared.fetchDriverLicenses { fetchedDriverLicenses in
            self.driverLicenses = fetchedDriverLicenses
            self.driverLicensesTableView.reloadData()
            self.driverLicenseTableViewHeight.constant = CGFloat(self.driverLicenses.count) * self.driverLicensesTableView.rowHeight + 10
            self.driverLicenseSuperViewHeight.constant = self.driverLicenseTableViewHeight.constant + 30
        }
    }
    
    private func configureCarsTableView() {
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        carsTableView.rowHeight = 80
        carsTableView.isScrollEnabled = false

        carsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    private func configureDriverLicenseTableView() {
        driverLicensesTableView.delegate = self
        driverLicensesTableView.dataSource = self
        driverLicensesTableView.register(DriverLicenseTableViewCell.nib(), forCellReuseIdentifier: DriverLicenseTableViewCell.reuseIdentifier)
        driverLicensesTableView.rowHeight = 80
        driverLicensesTableView.isScrollEnabled = false

        driverLicensesTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Инструктор успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить инструктора в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let firstName = firstNameTextField.text, firstName != "" else {
            failureAlertView.present()
            return
        }
        
        guard let lastName = lastNameTextField.text, lastName != "" else {
            failureAlertView.present()
            return
        }
        
        guard let middleName = middleNameTextField.text, middleName != "" else {
            failureAlertView.present()
            return
        }
        
        guard let drivingExperience = drivingExperienceTextField.text, drivingExperience != "" else {
            failureAlertView.present()
            return
        }
        
        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else {
            failureAlertView.present()
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            failureAlertView.present()
            return
        }
        
        let selectedCarId = cars[selectedCarIndex].carId
        let selectedDriverLicenseId = driverLicenses[selectedDriverLicenseIndex].driverLicenseId
        
        let instructor = Instructor(instructorId: 0, firstName: firstName, lastName: lastName, middleName: middleName, drivingExperience: Int(drivingExperience) ?? 0, passportNumber: passportNumber, phoneNumber: phoneNumber, carId: selectedCarId, driverLicenseId: selectedDriverLicenseId)
        NetworkManager.shared.postInstructor(instructor)
        
        successAlertView.present()
    }

}

extension CreateInstruсtorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == carsTableView {
            return cars.count
        } else {
            return driverLicenses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == carsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as! CarTableViewCell
            
            let car = cars[indexPath.row]
            cell.setup(withCar: car)
            
            if indexPath.row == selectedCarIndex {
                cell.accessoryType = .checkmark
                cell.tintColor = .lightGreenSea
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverLicenseTableViewCell.reuseIdentifier, for: indexPath) as! DriverLicenseTableViewCell
            
            let driverLicense = driverLicenses[indexPath.row]
            cell.setup(withDriverLicense: driverLicense)
            
            if indexPath.row == selectedDriverLicenseIndex {
                cell.accessoryType = .checkmark
                cell.tintColor = .lightGreenSea
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == carsTableView {
            selectedCarIndex = indexPath.row
        } else {
            selectedDriverLicenseIndex = indexPath.row
        }
        tableView.reloadData()
    }
}

extension CreateInstruсtorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateInstruсtorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: carsTableView) || touch.view!.isDescendant(of: driverLicensesTableView) {
            return false
        }
        return true
    }
}


