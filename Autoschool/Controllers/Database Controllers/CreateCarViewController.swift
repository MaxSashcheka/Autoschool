//
//  CreateCarViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class CreateCarViewController: UIViewController {
    
    
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить машину"
        view.backgroundColor = UIColor.viewBackground

        
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
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
