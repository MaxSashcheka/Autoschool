//
//  UpdateCarViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class UpdateCarViewController: UIViewController {
    
    var selectedCar: Car!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изменить машину"
        view.backgroundColor = UIColor.viewBackground
        
        fillCarInfo()
        setupTapGesture()
        setupTextFields()
        setupBarButtonItems()
    }

}

// MARK: - Private interface

private extension UpdateCarViewController {
    
    func fillCarInfo() {
        numberTextField.text = selectedCar.number
        nameTextField.text = selectedCar.name
        colorTextField.text = selectedCar.color
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupTextFields() {
        numberTextField.delegate = self
        nameTextField.delegate = self
        colorTextField.delegate = self
    }
    
    func setupBarButtonItems() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let deleteCarItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteCarHandler))
        deleteCarItem.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [saveItem, deleteCarItem]
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteCarHandler() {
        
    }
    
    @objc func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Машина успешно обновлена в базе данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось обновить машину в базе данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let number = numberTextField.text, number != "" else {
            failureAlertView.present()
            return
        }
        
        guard let name = nameTextField.text, name != "" else {
            failureAlertView.present()
            return
        }
        
        guard let color = colorTextField.text, color != "" else {
            failureAlertView.present()
            return
        }
        
        let car = Car(carId: selectedCar.carId, number: number, name: name, color: color)
        NetworkManager.shared.updateCar(car)
        
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
