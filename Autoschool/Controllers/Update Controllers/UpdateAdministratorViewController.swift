//
//  UpdateAdministratorViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/6/21.
//

import UIKit

class UpdateAdministratorViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Администратор"
        view.backgroundColor = UIColor.viewBackground
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupBarButtonItems()
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Обновить", style: .plain, target: self, action: #selector(updateAdministrator))
    }
    
    @objc private func updateAdministrator() {
        let successAlertView = SPAlertView(title: "Администратор обновлен в базе данных", preset: .done)
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

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
}


extension UpdateAdministratorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
}
