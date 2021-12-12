//
//  CreateWorkerViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit


class CreateAdministratorViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var administrators = [Administrator]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchAdministrators { [weak self] fetchedAdministrators in
            guard let self = self else { return }
            self.administrators = fetchedAdministrators
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Добавить администратора"
        view.backgroundColor = UIColor.viewBackground
        
        setupTextFields()
        setupTapGesture()
        setupBarButtonItems()
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
    }
    
    
    
}

// MARK: - Private interface

private extension CreateAdministratorViewController {

    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        middleNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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

        let failureAlertView = SPAlertView(title: "Не удалось добавить администратора в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        guard let password = passwordTextField.text, password != "" else {
            failureAlertView.present()
            return
        }
        
        if phoneNumber.count < 19 {
            let myMessage = "Номер телефона имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        for administrator in administrators {
            if administrator.email == email || administrator.phoneNumber == phoneNumber {
                let myMessage = "Невозможно добавить администратора, так как указанная электронная почта или телефон уже находятся в базе данных"
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
                
                return
            }
    
        }
        
        let administrator = Administrator(administratorId: 0, firstName: firstName, lastName: lastName, middleName: middleName, phoneNumber: phoneNumber, email: email, password: password)
        NetworkManager.shared.postAdministrator(administrator)
        
        navigationController?.popViewController(animated: true)

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

extension CreateAdministratorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 32 { return false }
        
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
            return false
        }
       return true
    }
    
}
