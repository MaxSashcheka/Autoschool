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
        
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let successAlertView = SPAlertView(title: "Инструктор успешно добавлен в базу данных", preset: .done)
        let failureAlertView = SPAlertView(title: "Не удалось добавить инструктора в базу данных", message: "Вы заполнили не все поля", preset: .error)
        
        guard let carNumber = carNumberTextField.text, carNumber != "" else {
            failureAlertView.present()
            return
        }
        
        guard let carName = carNameTextField.text, carName != "" else {
            failureAlertView.present()
            return
        }
        
        guard let carColor = carColorTextField.text, carColor != "" else {
            failureAlertView.present()
            return
        }
        
        successAlertView.present()
    }
    

}
