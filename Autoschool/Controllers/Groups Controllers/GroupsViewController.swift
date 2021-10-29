//
//  GroupsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class GroupsViewController: UIViewController {
    
    var student0 = Student(firstName: "Имя", lastName: "Фамилия", patronymic: "Отчество", passportNumber: "МР3333333", phoneNumber: "+375 (29) 358-17-24", instructorName: "Иванов Иван Иванович")
    var student1 = Student(firstName: "Имя", lastName: "Фамилия", patronymic: "Отчество", passportNumber: "МР3333333", phoneNumber: "+375 (29) 358-17-24", instructorName: "Иванов Иван Иванович")
    var student2 = Student(firstName: "Имя", lastName: "Фамилия", patronymic: "Отчество", passportNumber: "МР3333333", phoneNumber: "+375 (29) 358-17-24", instructorName: "Иванов Иван Иванович")
    
    lazy var dataSource = [
        Group(name: "Группа-14", category: .AutomaticB, dayPart: .evening, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2, student0, student1, student2,]),
        Group(name: "Группа-19", category: .ManuallyB, dayPart: .morning, startLessonsDate: "24.07.2021", endLesonnsDate: "18.11.2022", students: [student1, student2,student0, student1, student2,]),
        Group(name: "Группа-24", category: .a, dayPart: .evening, startLessonsDate: "24.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2,]),
        Group(name: "Группа-9", category: .AutomaticB, dayPart: .morning, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0,]),
        Group(name: "Группа-24", category: .a, dayPart: .morning, startLessonsDate: "24.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1]),
    ]
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var selectedGroupIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        setupNavigation()
    }
    
    private func configureCollectionView() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCell.nib(), forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
    }

    private func setupNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Группы"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
        navigationController?.navigationBar.tintColor = .lightGreenSea
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension GroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier, for: indexPath) as! GroupCell
        
        let group = dataSource[indexPath.row]
        cell.setup(withGroup: group)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GroupsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width - groupsCollectionViewInsets.left * 2
        let itemHeight = itemWidth / 1.85
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return groupsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Groups", bundle: nil).instantiateViewController(identifier: "StudentsViewController") as! StudentsViewController
        let selectedGroup = dataSource[indexPath.item]
        viewController.group = selectedGroup
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
