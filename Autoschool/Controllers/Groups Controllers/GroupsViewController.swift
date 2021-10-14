//
//  GroupsViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class GroupsViewController: UIViewController {
    
    var student0 = Student(firstName: "Максим", lastName: "Сащеко", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Малашкевич Денисааа")
    var student1 = Student(firstName: "РОМАН", lastName: "КАПЧАН", patronymic: "АНДРЕЕВИЧ", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")
    var student2 = Student(firstName: "АРТЕМ", lastName: "Малашкевич", patronymic: "Сащеко", passportNumber: "МР3718032", phoneNumber: "+375 (29) 358-17-24", instructorName: "Скурат Денис")
    
    lazy var dataSource = [
        Group(name: "Группа-14", category: .AutomaticB, dayPart: .evening, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2, student0, student1, student2,]),
        Group(name: "Группа-19", category: .ManuallyB, dayPart: .morning, startLessonsDate: "24.07.2021", endLesonnsDate: "18.11.2022", students: [student1, student2,student0, student1, student2,]),
        Group(name: "Группа-24", category: .a, dayPart: .evening, startLessonsDate: "24.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0, student1, student2,]),
        Group(name: "Группа-9", category: .AutomaticB, dayPart: .morning, startLessonsDate: "14.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1, student2,student0, student1, student2,student0,]),
        Group(name: "Группа-24", category: .a, dayPart: .morning, startLessonsDate: "24.01.2021", endLesonnsDate: "18.02.2022", students: [student0, student1]),
    ]

    @IBOutlet weak var groupsCollectionViewPageControl: UIPageControl!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    let groupsCollectionViewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var selectedGroupIndex = 0
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureTableView()
        setupNavigation()
    }
    
    private func configureCollectionView() {
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(GroupCell.nib(), forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
    }
    
    private func configureTableView() {
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        studentsTableView.register(StudentTableViewCell.nib(), forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier)
    }
 
    private func setupNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Группы"
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")!
        navigationController?.navigationBar.tintColor = .black
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension GroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupsCollectionViewPageControl.numberOfPages = dataSource.count
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier, for: indexPath) as! GroupCell
        
        let group = dataSource[indexPath.row]
        cell.setup(withGroup: group)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        groupsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if selectedGroupIndex == indexPath.row {
            return // Если мы не просвайпали, а остались на том же элементе
        }
        selectedGroupIndex = indexPath.row
        groupsCollectionViewPageControl.currentPage = indexPath.item
        
        studentsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        studentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GroupsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width - groupsCollectionViewInsets.left * 2
        let itemHeight = itemWidth / 2.0
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return groupsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return groupsCollectionViewInsets.left * 2
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[selectedGroupIndex].students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier, for: indexPath) as! StudentTableViewCell
        
        let selectedGroup = dataSource[selectedGroupIndex]
        let student = selectedGroup.students[indexPath.row]
        cell.setup(withStudent: student,row: indexPath.row)
        
        return cell
    }
    
}
