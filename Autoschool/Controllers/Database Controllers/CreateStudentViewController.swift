//
//  CreateStudentViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateStudentViewController: UIViewController {

    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    var selectedGroupIndex = 0

    @IBOutlet weak var instructorsTableView: UITableView!
    @IBOutlet weak var instructorsTableViewSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instructorsTableViewHeight: NSLayoutConstraint!
    let instructorsTableViewCellsCount = 7
    var selectedInstructorIndex = 0
    
    var student0 = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")
    var student1 = Student(firstName: "Артем", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")
    var student2 = Student(firstName: "Максим", lastName: "Малашкевич", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")

    lazy var group = Group(name: "Группа-14", category: .AutomaticB, dayPart: .evening, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2, student0, student1, student2,])
    
    let instructor0 = Instructor(firstName: "Артем", lastName: "Малашкевич", patronymic: "Викторович", phoneNumber: "+375 (29) 358-17-24", drivingExperience: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить ученика"
        
        instructorsTableView.rowHeight = 40

        configureCollectionViews()
        configureTableView()
        setupBarButtonItems()
    }
    
    private func configureCollectionViews() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCell.nib(), forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
    }
    
    private func configureTableView() {
        instructorsTableView.delegate = self
        instructorsTableView.dataSource = self
        instructorsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "instructorsTableView")
        instructorsTableView.isScrollEnabled = false
        
        instructorsTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        instructorsTableViewHeight.constant = CGFloat(instructorsTableViewCellsCount) * instructorsTableView.rowHeight + 10
        instructorsTableViewSuperViewHeight.constant = instructorsTableViewHeight.constant + 40
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
    }
    
    @objc private func saveButtonHandler() {
        
        let alertView = SPAlertView(title: "Successfuly added some feature", preset: .done)
        alertView.present(haptic: .success, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension CreateStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier, for: indexPath) as! GroupCell
        cell.setup(withGroup: group)
        
        // Check for selection
        if indexPath.item == selectedGroupIndex {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGroupIndex = indexPath.item
        groupsCollectionView.reloadData()
        groupsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateStudentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = groupsCollectionView.frame.width * 0.8
        let itemHeight = groupsCollectionView.frame.height - groupsCollectionViewInsets.top * 2
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return groupsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.left
    }
}

extension CreateStudentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructorsTableViewCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instructorsTableView", for: indexPath)
        
        if indexPath.row == selectedInstructorIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = "Сащеко Максим Андреевич"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInstructorIndex = indexPath.row
        tableView.reloadData()
    }
    
}
