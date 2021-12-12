//
//  CreateDriverLicenseViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/4/21.
//

import UIKit

class CreateDriverLicenseViewController: UIViewController {
    
    var driverLicenses = [DriverLisence]()

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var issueDateTextField: UITextField!
    @IBOutlet weak var validityTextField: UITextField!
    
    lazy var issueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchDriverLicenses { [weak self] fetchedDriverLicenses in
            guard let self = self else { return }

            self.driverLicenses = fetchedDriverLicenses
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Добавить удостоверение"
        view.backgroundColor = UIColor.viewBackground
        
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
    }

}

// MARK: - Private interface

private extension CreateDriverLicenseViewController {
    
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
        
        if number.count < 7 {
            let myMessage = "Номер имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        for driverLicense in driverLicenses {
            if driverLicense.number == number {
                let myMessage = "Невозможно водительское удостоверение, так как указанный номер уже есть в базе данных"
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
                
                return 
            }
        }

        let driverLicense = DriverLisence(driverLicenseId: 0, issueDate: issueDateString, number: number, validity: Int(validity) ?? 0)
        NetworkManager.shared.postDriverLicense(driverLicense)
        navigationController?.popViewController(animated: true)

    }
}

// MARK: - UITextFieldDelegate

extension CreateDriverLicenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            if range.location > 6 { return false }
        }
        if range.location > 32 { return false }
        return true

    }
}
