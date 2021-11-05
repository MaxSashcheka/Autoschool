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
    
    lazy var instructorTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarTableViewCell.nib(), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        tableView.register(DriverLicenseTableViewCell.nib(), forCellReuseIdentifier: DriverLicenseTableViewCell.reuseIdentifier)
        tableView.rowHeight = 85
        tableView.backgroundColor = .clear

        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(instructorTableView)
        title = "\(instructor.lastName) \(instructor.firstName)"
        view.backgroundColor = UIColor.viewBackground
    }
    
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
    }
    

}

extension InstructorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Водительское удостоверение"
        } else {
            return "Машина"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverLicenseTableViewCell.reuseIdentifier, for: indexPath) as! DriverLicenseTableViewCell
            if let selectedDriverLicense = selectedDriverLicense {
                cell.setup(withDriverLicense: selectedDriverLicense)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as! CarTableViewCell
            if let selectedCar = selectedCar {
                cell.setup(withCar: selectedCar)
            }
            return cell
        }
    }

}
