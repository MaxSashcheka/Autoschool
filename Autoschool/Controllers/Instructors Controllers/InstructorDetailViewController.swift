//
//  InstructorDetailViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/5/21.
//

import UIKit

class InstructorDetailViewController: UIViewController {
    
    var instructor: Instructor!
    var selectedDriverLicense: DriverLisence!
    var selectedCar: Car!
    var students = [Student]()
    
    lazy var instructorTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        tableView.register(DriverLicenseTableViewCell.nib(), forCellReuseIdentifier: DriverLicenseTableViewCell.reuseIdentifier)
        tableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchCars { fetchedCars in
            for car in fetchedCars {
                if car.carId == self.instructor.carId {
                    self.selectedCar = car
                    break
                }
            }
            self.instructorTableView.reloadData()
        }
        NetworkManager.shared.fetchDriverLicenses { fetchedDriverLicense in
            for driverLicense in fetchedDriverLicense {
                if driverLicense.driverLicenseId == self.instructor.driverLicenseId {
                    self.selectedDriverLicense = driverLicense
                    break
                }
            }
            self.instructorTableView.reloadData()
        }
        NetworkManager.shared.fetchStudents { fetchedStudent in
            var instructorRelatedStudents = [Student]()
            for student in fetchedStudent {
                if student.instructorId == self.instructor.instructorId {
                    instructorRelatedStudents.append(student)
                }
            }
            self.students = instructorRelatedStudents
            self.instructorTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(instructorTableView)
        title = "\(instructor.lastName) \(instructor.firstName)"
        view.backgroundColor = UIColor.viewBackground

        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(openUpdateInstructorController))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc private func openUpdateInstructorController() {
        let updateGroupVC = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(identifier: "UpdateInstructorViewController")
        self.navigationController?.pushViewController(updateGroupVC, animated: true)
    }

}

extension InstructorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Водительское удостоверение"
        } else if section == 1{
            return "Машина"
        } else {
            return "Ученики"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 100
        } else {
            return 83
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverLicenseTableViewCell.reuseIdentifier, for: indexPath) as! DriverLicenseTableViewCell
            if let selectedDriverLicense = selectedDriverLicense {
                cell.setup(withDriverLicense: selectedDriverLicense)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as! CarTableViewCell
            if let selectedCar = selectedCar {
                cell.setup(withCar: selectedCar)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
            let student = students[indexPath.row]
            cell.setup(withStudent: student, andInstructor: instructor)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
