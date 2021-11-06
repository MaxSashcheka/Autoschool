//
//  UpdateDriverLicenseViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/4/21.
//

import UIKit

class UpdateDriverLicenseViewController: UIViewController {

    var selectedDriverLicense: DriverLisence!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var issueDateTextField: UITextField!
    @IBOutlet weak var validityTextField: UITextField!
    
    lazy var issueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить удостоверение"
        view.backgroundColor = UIColor.viewBackground
        
        fillDriverLicenseInfo()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }

}

// MARK: - Private interface

private extension UpdateDriverLicenseViewController {
    
    func fillDriverLicenseInfo() {
        numberTextField.text = selectedDriverLicense.number
        validityTextField.text = String(selectedDriverLicense.validity)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let endOfDate = String.Index(encodedOffset: 9)
        let stringDate = String(selectedDriverLicense.issueDate[...endOfDate])
        let date = dateFormatter.date(from: stringDate)!
        issueDatePicker.date = date
        
        issueDateTextField.text = dateFormatter.string(from: date)
    }
    
    func setupTextFields () {
        let startDateToolbar = UIToolbar()
        startDateToolbar.sizeToFit()
        let issueDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveIssueDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        startDateToolbar.setItems([flexSpace, issueDateDoneButton], animated: true)
        
        issueDateTextField.inputView = issueDatePicker
        issueDateTextField.inputAccessoryView = startDateToolbar
        
        numberTextField.delegate = self
        validityTextField.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func saveIssueDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        issueDateTextField.text = formatter.string(from: issueDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Удостоверение успешно добавлено в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить удостоверение в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let number = numberTextField.text, number != "" else {
            failureAlertView.present()
            return
        }
        
        guard let issueDateString = issueDateTextField.text, issueDateString != "" else {
            failureAlertView.present()
            return
        }
        
        guard let validity = validityTextField.text, validity != "" else {
            failureAlertView.present()
            return
        }

        let driverLicense = DriverLisence(driverLicenseId: 0, issueDate: issueDateString, number: number, validity: Int(validity) ?? 0)
        NetworkManager.shared.postDriverLicense(driverLicense)
        
        successAlertView.present()
    }
}

// MARK: - UITextFieldDelegate

extension UpdateDriverLicenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
