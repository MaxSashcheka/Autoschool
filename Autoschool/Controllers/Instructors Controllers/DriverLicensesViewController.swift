//
//  DriverLicensesViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/4/21.
//

import UIKit

class DriverLicensesViewController: UIViewController {
    
    var driverLicenses = [DriverLisence]()
    
    lazy var driverLicensesTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DriverLicenseTableViewCell.nib(), forCellReuseIdentifier: DriverLicenseTableViewCell.reuseIdentifier)
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(driverLicensesTableView)
        title = "Удостоверения"
        view.backgroundColor = UIColor.viewBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.shared.fetchDriverLicenses { fetchedDriverLicenses in
            self.driverLicenses = fetchedDriverLicenses
            self.driverLicensesTableView.reloadData()
        }
    }
    

}

extension DriverLicensesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverLicenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DriverLicenseTableViewCell.reuseIdentifier, for: indexPath) as! DriverLicenseTableViewCell
        
        let driverLicense = driverLicenses[indexPath.row]
        cell.setup(withDriverLicense: driverLicense)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let driverLicenseId = driverLicenses[indexPath.row].driverLicenseId
            NetworkManager.shared.deleteDriverLicense(withId: driverLicenseId)
            driverLicenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }

}
