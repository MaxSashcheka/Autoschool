//
//  CreateCarViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class CreateCarViewController: UIViewController {
    
    var cars = [Car]()
    
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchCars { [weak self] fetchedCars in
            guard let self = self else { return }

            self.cars = fetchedCars
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Добавить машину"
        view.backgroundColor = UIColor.viewBackground
        
        setupTapGesture()
        setupTextFields()
        setupBarButtonItems()
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
    }

}

// MARK: - Private interface

private extension CreateCarViewController {
    
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
        
        if number.count < 9 {
            let myMessage = "Государственный номер имеет неправильный формат (недостаточно символов)"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        for car in cars {
            if car.number == number {
                let myMessage = "Невозможно добавить машину, так как указанный государственный номер уже есть в базе данных"
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
                
                return
            }
        }
        
        let car = Car(carId: 0, number: number, name: name, color: color)
        NetworkManager.shared.postCar(car)
        navigationController?.popViewController(animated: true)

    }
    
}

// MARK: - UITextFieldDelegate

extension CreateCarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == carNumberTextField {
            if range.location > 8 { return false }
        }
        if range.location > 32 { return false }
        
        return true
    }
}
