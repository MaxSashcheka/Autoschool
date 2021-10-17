//
//  CreateTeacherViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateTeacherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить преподавателя"

        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Преподаватель успешно добавлен в базу данных", preset: .done)
        alertView.present()

    }

}
