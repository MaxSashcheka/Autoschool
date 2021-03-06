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
        NetworkManager.shared.deleteCar(withId: selectedCar.carId)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonHandler() {
        
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
        
        if number.count < 9 {
            let myMessage = "Государственный номер имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        let car = Car(carId: selectedCar.carId, number: number, name: name, color: color)
        NetworkManager.shared.updateCar(car)
        navigationController?.popViewController(animated: true)

    }
    
}

// MARK: - UITextFieldDelegate

extension UpdateCarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            if range.location > 8 { return false }
        }
        if range.location > 32 { return false}
        return true

    }
}
