//
//  DatabaseMainViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

struct ViewControllerRepresentation {
    let name: String
    let identifier: String
    let image: UIImage?
}

class DatabaseMainViewController: UIViewController {
    
    let controllersRepresentationModel = [
        ViewControllerRepresentation(name: "Добавить администратора", identifier: "CreateAdministratorViewController", image: UIImage(named: "administrator")),
        ViewControllerRepresentation(name: "Добавить ученика", identifier: "CreateStudentViewController", image: UIImage(named: "student")),
        ViewControllerRepresentation(name: "Добавить договор", identifier: "CreateAgreementViewController", image: UIImage(named: "contract")),
        ViewControllerRepresentation(name: "Добавить инструктора", identifier: "CreateInstruсtorViewController", image: UIImage(named: "instructor")),
        ViewControllerRepresentation(name: "Добавить водительское удостоверение", identifier: "CreateDriverLicenseViewController", image: UIImage(named: "driverLicense")),
        ViewControllerRepresentation(name: "Добавить машину", identifier: "CreateCarViewController", image: UIImage(named: "car")),
        ViewControllerRepresentation(name: "Добавить группу", identifier: "CreateGroupViewController", image: UIImage(named: "group")),
        ViewControllerRepresentation(name: "Добавить преподователя теории", identifier: "CreateTeacherViewController", image: UIImage(named: "teacher")),
        ViewControllerRepresentation(name: "Добавить экзамен", identifier: "CreateExamViewController", image: UIImage(named: "exam")),
    ]
    
    
    @IBOutlet weak var databaseCollectionView: UICollectionView!
    let databaseCollectionViewInsets = UIEdgeInsets(top: 23, left: 15, bottom: 17, right: 15)
    var administrator: Administrator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewBackground
        
        setupDatabaseCollectionView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupDatabaseCollectionView() {
        databaseCollectionView.backgroundColor = .clear
        databaseCollectionView.delegate = self
        databaseCollectionView.dataSource = self
        databaseCollectionView.register(DatabaseCollectionViewCell.nib(), forCellWithReuseIdentifier: DatabaseCollectionViewCell.reuseIdentifier)
    }

    private func setupNavigation() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(administrator.lastName) \(administrator.firstName)"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        navigationController?.navigationBar.tintColor = .lightGreenSea
        let exitBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitHandler))
        exitBarButtonItem.tintColor = .systemRed
        navigationItem.rightBarButtonItem = exitBarButtonItem
    }
    
    @objc func exitHandler() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension DatabaseMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllersRepresentationModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatabaseCollectionViewCell.reuseIdentifier, for: indexPath) as! DatabaseCollectionViewCell
        
        let vcRepresentator = controllersRepresentationModel[indexPath.row]
        cell.setup(withRepresentator: vcRepresentator)
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DatabaseMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - databaseCollectionViewInsets.left * 2
        let itemHeight = CGFloat(90)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return databaseCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return databaseCollectionViewInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controllerIdentifier = controllersRepresentationModel[indexPath.row].identifier
        let viewController = UIStoryboard(name: "Database", bundle: nil).instantiateViewController(identifier: controllerIdentifier)

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


