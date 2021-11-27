//
//  UpdateTeacherViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class UpdateTeacherViewController: UIViewController {
    
    var selectedTeacher: Teacher!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить преподавателя"
        view.backgroundColor = UIColor.viewBackground
        
        fillTeacherInfo()
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
    }

}

// MARK: - Private interface

extension UpdateTeacherViewController {
    
    func fillTeacherInfo() {
        firstNameTextField.text = selectedTeacher.firstName
        lastNameTextField.text = selectedTeacher.lastName
        middleNameTextField.text = selectedTeacher.middleName
        passportNumberTextField.text = selectedTeacher.passportNumber
        phoneNumberTextField.text = selectedTeacher.phoneNumber
    }
    
    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        passportNumberTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteTeacherItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteTeacherHandler))
        deleteTeacherItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteTeacherItem]
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteTeacherHandler() {
        NetworkManager.shared.deleteTeacher(withId: selectedTeacher.teacherId)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Преподаватель успешно обновлен в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить преподавателя в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        let teacher = Teacher(teacherId: selectedTeacher.teacherId, firstName: firstName, lastName: lastName, middleName: middleName, passportNumber: passportNumber, phoneNumber: phoneNumber)
        NetworkManager.shared.updateTeacher(teacher)
        
        successAlertView.present()

    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

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

extension UpdateTeacherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 32 { return false}

        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
    
}
