//
//  UpdateCarViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class UpdateCarViewController: UIViewController {
    
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить машину"
        view.backgroundColor = UIColor.viewBackground
        
        setupTapGesture()
        setupTextFields()
        setupBarButtonItems()
    }

}

// MARK: - Private interface

private extension UpdateCarViewController {
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupTextFields() {
        carNumberTextField.delegate = self
        carNameTextField.delegate = self
        carColorTextField.delegate = self
    }
    
    func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Машина успешно добавлена в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить машину в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let number = carNumberTextField.text, number != "" else {
            failureAlertView.present()
            return
        }
        
        guard let name = carNameTextField.text, name != "" else {
            failureAlertView.present()
            return
        }
        
        guard let color = carColorTextField.text, color != "" else {
            failureAlertView.present()
            return
        }
        
        let car = Car(carId: 0, number: number, name: name, color: color)
        NetworkManager.shared.postCar(car)
        
        successAlertView.present()
    }
    
}

// MARK: - UITextFieldDelegate

extension UpdateCarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
