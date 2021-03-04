//
//  LoginViewController.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 03.03.21.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "usersignedin") {
            print("finally")
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {

        do { try Auth.auth().signOut()
                 UserDefaults.standard.setValue(nil, forKey: "UserPhotoURL")
        } catch {
            print("already logged out") }
        
        print("signed out")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
