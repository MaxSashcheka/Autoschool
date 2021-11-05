//
//  CreateTeacherViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateTeacherViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить преподавателя"
        view.backgroundColor = UIColor.viewBackground

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        passportNumberTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupBarButtonItems()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Преподаватель успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить преподавателя в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else {
            failureAlertView.present()
            return
        }
        
        let teacher = Teacher(teacherId: 0, firstName: firstName, lastName: lastName, middleName: middleName, passportNumber: passportNumber, phoneNumber: phoneNumber)
        NetworkManager.shared.postTeacher(teacher)
        
        
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

extension CreateTeacherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
        return false
    }
}
