//
//  CreateGroupViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupNameLabel: UITextField!
    
    @IBOutlet weak var drivingCategorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var classesTimeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    lazy var startLessonsDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    lazy var endLessonsDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date

        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить группу"
        
        configureSegmentedControls()
        configureTextFields()
        setupBarButtonItems()
    }
    
    private func configureSegmentedControls() {
        drivingCategorySegmentedControl.selectedSegmentTintColor = .lightGreenSea
        drivingCategorySegmentedControl.layer.borderWidth = 1
        drivingCategorySegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        drivingCategorySegmentedControl.backgroundColor = .white
        
        classesTimeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        classesTimeSegmentedControl.layer.borderWidth = 1
        classesTimeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        classesTimeSegmentedControl.backgroundColor = .white
    }
    
    private func configureTextFields() {
        let startDateToolbar = UIToolbar()
        startDateToolbar.sizeToFit()
        let startDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveStartDate))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        startDateToolbar.setItems([flexSpace, startDateDoneButton], animated: true)
        
        startDateTextField.inputView = startLessonsDatePicker
        startDateTextField.inputAccessoryView = startDateToolbar
        
        let endDateToolbar = UIToolbar()
        endDateToolbar.sizeToFit()
        let endDateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveEndDate))
        endDateToolbar.setItems([flexSpace, endDateDoneButton], animated: true)
        
        startDateTextField.inputView = startLessonsDatePicker
        startDateTextField.inputAccessoryView = startDateToolbar
        
        endDateTextField.inputView = endLessonsDatePicker
        endDateTextField.inputAccessoryView = endDateToolbar
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc func saveStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        startDateTextField.text = formatter.string(from: startLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func saveEndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        endDateTextField.text = formatter.string(from: endLessonsDatePicker.date)
        
        view.endEditing(true)
    }
    
    @objc private func saveButtonHandler() {
        
    }
    

}

