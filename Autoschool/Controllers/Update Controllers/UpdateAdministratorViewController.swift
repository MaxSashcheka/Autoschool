//
//  UpdateAdministratorViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit


class UpdateAdministratorViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var administrator: Administrator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить администратора"
        view.backgroundColor = UIColor.viewBackground
        
        fillAdministratorInfo()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }
}

// MARK: - Private interface

private extension UpdateAdministratorViewController {
    
    func fillAdministratorInfo() {
        firstNameTextField.text = administrator.firstName
        lastNameTextField.text = administrator.lastName
        middleNameTextField.text = administrator.middleName
        phoneNumberTextField.text = administrator.phoneNumber
        emailTextField.text = administrator.email
    }

    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Администратор успешно обновлен в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить администратора в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            failureAlertView.present()
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            failureAlertView.present()
            return
        }
        
        let administrator = Administrator(administratorId: 0, firstName: firstName, lastName: lastName, middleName: middleName, phoneNumber: phoneNumber, email: email)
        NetworkManager.shared.postAdministrator(administrator)
        
        successAlertView.present()
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}

// MARK: - UITextFieldDelegate

extension UpdateAdministratorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+ XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
    
}
