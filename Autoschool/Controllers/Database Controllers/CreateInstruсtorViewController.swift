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
    @IBOutlet weak var patronymicTextField: UITextField!
    
    @IBOutlet weak var drivingExperienceTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var carsTableView: UITableView!
    var selectedCarIndex = 0
    
    @IBOutlet weak var carsSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var carsTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить инструктора"
        
        setupBarButtonItems()
        configureCarsTableView()
        
    }
    
    private func configureCarsTableView() {
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        carsTableView.rowHeight = 80
        carsTableView.isScrollEnabled = false

        carsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        carsTableViewHeight.constant = CGFloat(cars.count) * carsTableView.rowHeight + 10
        carsSuperViewHeight.constant = carsTableViewHeight.constant + 40
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
        
        guard let patronymic = patronymicTextField.text, patronymic != "" else {
            failureAlertView.present()
            return
        }
        
        guard let drivingExperience = drivingExperienceTextField.text, drivingExperience != "" else {
            failureAlertView.present()
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            failureAlertView.present()
            return
        }
        
        successAlertView.present()
    }

}

extension CreateInstruсtorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath)
        
        if indexPath.row == selectedCarIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .lightGreenSea
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        selectedCarIndex = indexPath.row
        tableView.reloadData()
    }
    
    
}


