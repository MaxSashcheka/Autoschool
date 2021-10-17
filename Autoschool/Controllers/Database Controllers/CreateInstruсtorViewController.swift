//
//  CreateInstruktorViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateInstruсtorViewController: UIViewController {

    var studentExample = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")
    
    
    
    @IBOutlet weak var carTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var carsTableView: UITableView!
    let carsTableViewCellsCount = 5
    var selectedCarIndex = 0
    
    @IBOutlet weak var carsSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var carsTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить инструктора"
        
        setupBarButtonItems()
        configureCarsTableView()
        configureSegmentedControl()
    }
    
    private func configureCarsTableView() {
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        carsTableView.rowHeight = 80
        carsTableView.isScrollEnabled = false

        carsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        carsTableViewHeight.constant = CGFloat(carsTableViewCellsCount) * carsTableView.rowHeight + 10
        carsSuperViewHeight.constant = carsTableViewHeight.constant + 20
    }
    
    private func configureSegmentedControl() {
        carTypeSegmentedControl.selectedSegmentTintColor = .lightGreenSea
        carTypeSegmentedControl.layer.borderWidth = 1
        carTypeSegmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        carTypeSegmentedControl.backgroundColor = .white
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        let alertView = SPAlertView(title: "Инструктор успешно добавлен в базу данных", preset: .done)
        alertView.present()
    }

}

extension CreateInstruсtorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsTableViewCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath)
        
        if indexPath.row == selectedCarIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .lightGreenSea
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        selectedCarIndex = indexPath.row
        tableView.reloadData()
    }
    
    
}


