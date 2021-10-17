//
//  CreateWorkerViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit


class CreateWorkerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить администратора"

        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Successfully added", message: "Thanks for adding to database", preset: .custom(UIImage(systemName: "person") ?? .add))
        alertView.present()
    

    }
    
    
    
}
