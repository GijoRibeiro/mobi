//
//  AddPostViewController.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.03.21.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController {
    
    let database = Database.database().reference()

    @IBOutlet weak var btnAddPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAddPost(_ sender: Any) {
        
    }
}

