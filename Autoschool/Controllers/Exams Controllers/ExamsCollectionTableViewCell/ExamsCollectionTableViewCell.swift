//
//  ExamsCollectionTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/8/21.
//

import UIKit

protocol ExamDetailDelegate {
    func pushUpdateExamController(withExam exam: Exam)
}

class ExamsCollectionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ExamsCollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    var exams = [Exam]()
    var groups = [Group]()
    
    @IBOutlet weak var examsCollectionView: UICollectionView!
    let examsCollectionViewInsets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    var delegate: ExamDetailDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        examsCollectionView.delegate = self
        examsCollectionView.dataSource = self
        examsCollectionView.register(ExamCollectionViewCell.nib(), forCellWithReuseIdentifier: ExamCollectionViewCell.reuseIdentifier)
        examsCollectionView.isScrollEnabled = false
        examsCollectionView.backgroundColor = .clear
    }
    
    func setup(withExams exams: [Exam], groups: [Group]) {
        self.exams = exams
        self.groups = groups
        
        examsCollectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ExamsCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExamCollectionViewCell.reuseIdentifier, for: indexPath) as! ExamCollectionViewCell
        
        let exam = exams[indexPath.row]
        for group in groups {
            if exam.groupId == group.groupId {
                cell.setup(withExam: exam, andGroup: group)
            }
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExamsCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width - examsCollectionViewInsets.left * 2
        let itemHeight = itemWidth / 2.3
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return examsCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return examsCollectionViewInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedExam = exams[indexPath.row]
        delegate.pushUpdateExamController(withExam: selectedExam)
    }
    
}



