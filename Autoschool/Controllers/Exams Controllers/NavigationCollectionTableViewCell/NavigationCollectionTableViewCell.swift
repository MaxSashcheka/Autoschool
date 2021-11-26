//
//  TypePickerCollectionTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/8/21.
//

import UIKit

enum InternalExternalOption {
    case all
    case autoschool
    case gai
}

protocol InternalExternalRepresentationDelegate {
    func changeRepresentation(forOption option: InternalExternalOption)
}

protocol GroupPickerDelegate {
    func changeSelected(groupId: Int)
}

class NavigationCollectionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NavigationCollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var internalExternalCollectionView: UICollectionView!
    var selectedInternalExternalIndex = 0
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    var selectedGroupIndex = 0

    let collectionViewInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    var internalExternalCollectionViewContentWidth: CGFloat = 0
    
    var groups = [Group]()
    var internalExternalModel = ["Все", "Автошкола", "Гаи"]
    
    var internalExternalDelegate: InternalExternalRepresentationDelegate!
    var groupPickerDelegate: GroupPickerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setupCollectionViews()
    }

    func setup(withGroups groups: [Group], internalExternalOption: InternalExternalOption) {
        switch internalExternalOption {
        case .all: selectedInternalExternalIndex = 0
        case .autoschool: selectedInternalExternalIndex = 1
        case .gai: selectedInternalExternalIndex = 2
        }
        
        self.groups = groups
        self.groups.insert(Group(groupId: 0, name: "Все группы", lessonsStartDate: "", lessonsEndDate: "", categoryId: 1, category: .init(categoryId: 1, categoryName: ""), teacherId: 1, lessonsTimeId: 1, lessonsTime: .init(lessonsTimeId: 1, lessonsTimeName: "")), at: 0)
        groupsCollectionView.reloadData()
        
    }
    
    func setupCollectionViews() {
        internalExternalCollectionView.delegate = self
        internalExternalCollectionView.dataSource = self
        internalExternalCollectionView.register(NavigationCollectionViewCell.nib(), forCellWithReuseIdentifier: NavigationCollectionViewCell.reuseIdentifier)
        internalExternalCollectionView.backgroundColor = .clear
        internalExternalCollectionView.showsHorizontalScrollIndicator = false
        
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        groupsCollectionView.register(NavigationCollectionViewCell.nib(), forCellWithReuseIdentifier: NavigationCollectionViewCell.reuseIdentifier)
        groupsCollectionView.backgroundColor = .clear
        groupsCollectionView.showsHorizontalScrollIndicator = false
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension NavigationCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == internalExternalCollectionView {
            return 3
        } else {
            return groups.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == internalExternalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCollectionViewCell.reuseIdentifier, for: indexPath) as! NavigationCollectionViewCell
            
            let title = internalExternalModel[indexPath.row]
            cell.setup(withTitle: title)
            
            if indexPath.row == selectedInternalExternalIndex {
                cell.setSelectedState()
            } else {
                cell.setUnselectedState()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCollectionViewCell.reuseIdentifier, for: indexPath) as! NavigationCollectionViewCell
            
            let group = groups[indexPath.row]
            cell.setup(withGroup: group)
            
            if indexPath.row == selectedGroupIndex {
                cell.setSelectedState()
            } else {
                cell.setUnselectedState()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == internalExternalCollectionView {
            selectedInternalExternalIndex = indexPath.row
            
            switch indexPath.row {
            case 0: internalExternalDelegate.changeRepresentation(forOption: .all)
            case 1: internalExternalDelegate.changeRepresentation(forOption: .autoschool)
            case 2: internalExternalDelegate.changeRepresentation(forOption: .gai)
            default: print("Error")
            }
            
            internalExternalCollectionView.reloadData()
        } else {
            selectedGroupIndex = indexPath.row
            groupsCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
            groupsCollectionView.reloadData()
            
            let selectedGroup = groups[indexPath.row]
            groupPickerDelegate.changeSelected(groupId: selectedGroup.groupId)
        }
        
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NavigationCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == internalExternalCollectionView {
            let paddings = collectionViewInsets.left * CGFloat(internalExternalModel.count + 1)
            
            let itemWidth = (collectionView.frame.width - paddings) / CGFloat(internalExternalModel.count)
            let itemHeight = collectionView.frame.height - collectionViewInsets.top * 2
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let string = groups[indexPath.row].name
            let itemWidth = string.widthOfString(usingFont: UIFont.systemFont(ofSize: 22, weight: .semibold)) + 30
            let itemHeight = CGFloat(53)
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewInsets.left
    }
    
}





