//
//  AgreementsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/18/21.
//

import UIKit

class AgreementsViewController: UIViewController {
    
    var agreements = [Agreement]()
    var administrators = [Administrator]()
    var students = [Student]()
    
    lazy var agreementsTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AgreementTableViewCell.nib(), forCellReuseIdentifier: AgreementTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.shared.fetchAgreements { [weak self] fetchedAgreements in
            guard let self = self else { return }

            self.agreements = fetchedAgreements
            self.agreementsTableView.reloadData()
        }
        NetworkManager.shared.fetchAdministrators { [weak self] fetchedAdministrators in
            guard let self = self else { return }

            self.administrators = fetchedAdministrators
            self.agreementsTableView.reloadData()
        }
        NetworkManager.shared.fetchStudents { [weak self] fetchedStudents in
            guard let self = self else { return }

            self.students = fetchedStudents
            self.agreementsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список договоров"
        view.backgroundColor = UIColor.viewBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        view.addSubview(agreementsTableView)
    }
    
}

extension AgreementsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgreementTableViewCell.reuseIdentifier, for: indexPath) as! AgreementTableViewCell
        
        let agreement = agreements[indexPath.row]
        for administrator in administrators {
            if agreement.administratorId == administrator.administratorId {
                for student in students {
                    if agreement.studentId == student.studentId {
                        cell.setup(withAgreement: agreement, administrator: administrator, student: student)

                    }
                }
            }
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let agreementId = agreements[indexPath.row].agreementId
            NetworkManager.shared.deleteAgreement(withId: agreementId)
            agreements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateAdministratorVC = UIStoryboard(name: "Administration", bundle: nil).instantiateViewController(identifier: "UpdateAgreementViewController") as! UpdateAgreementViewController
        
        let selectedAgreement = agreements[indexPath.row]
        updateAdministratorVC.selectedAgreement = selectedAgreement
        
        self.navigationController?.pushViewController(updateAdministratorVC, animated: true)
    }
    
    
}
