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
    @IBOutlet weak var patronymicTextField: UITextField!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить преподавателя"

        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Ученик успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить ученика в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
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
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
            failureAlertView.present()
            return
        }
        
        guard let passportNumber = passportNumberTextField.text, passportNumber != "" else {
            failureAlertView.present()
            return
        }
        
        successAlertView.present()

    }

}
