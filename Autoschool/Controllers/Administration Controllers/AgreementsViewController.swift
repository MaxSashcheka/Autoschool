//
//  AgreementsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/18/21.
//

import UIKit

class AgreementsViewController: UIViewController {
    
    var agreements = [Agreement]()
    
    lazy var agreementsTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AgreementTableViewCell.nib(), forCellReuseIdentifier: AgreementTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список договоров"
        view.backgroundColor = .systemGray5
        
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
        cell.setup(withAgreement: agreement)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}
