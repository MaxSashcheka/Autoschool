//
//  CreateExamViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class CreateExamViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить экзамен"
        
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Экзамен успешно добавлен в базу данных", preset: .done)
        alertView.present()

    }


}
