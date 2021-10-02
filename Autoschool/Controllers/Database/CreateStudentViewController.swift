//
//  CreateStudentViewController.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class CreateStudentViewController: UIViewController {

    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var groupsCollectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить ученика"


        
    }
    


    
    

}
