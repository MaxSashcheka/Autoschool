//
//  CreateAgreementViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CreateAgreementViewController: UIViewController {

    
    lazy var signingDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить договор"

        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        
    }

}
