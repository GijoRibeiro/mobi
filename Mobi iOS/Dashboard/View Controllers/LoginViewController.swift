//
//  LoginViewController.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 03.03.21.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnGoogleSignCover: UIButton!
    @IBOutlet weak var pointBulletOne: UILabel!
    @IBOutlet weak var pointBulletTwo: UILabel!
    @IBOutlet weak var pointBulletThree: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var loginTableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    let actionItems = [["Your Likes", "Your snippets", "Logout"], ["Sign out"]]
    let sectionTitles = ["General", "Account"]
    
    //only shows of signed in
    @IBOutlet weak var ifLoggedInView: UIView!
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        loginTableView.delegate = self
        loginTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfLoggedIn), name: Notification.Name("UserSignedIn"), object: nil)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        screenTitle.textColor = .label
        
        customBtnGoogleSignIn()
        customPointBullets()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        checkIfLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        checkIfLoggedIn()
    }
    
    func didTapLogout() {

        do { try Auth.auth().signOut()
                 UserDefaults.standard.setValue(nil, forKey: "UserPhotoURL")
                 UserDefaults.standard.setValue(false, forKey: "isUserSignedIn")
        } catch {
            print("already logged out")
        }
        
        checkIfLoggedIn()
        print("signing out...")
    }
    
    func customBtnGoogleSignIn() {
        let googleLogo = "google.png"
        let image = UIImage(named: googleLogo)
        let imageView = UIImageView(image: image!)
        
        btnGoogleSignCover.backgroundColor = .label
        btnGoogleSignCover.tintColor = .systemBackground
        btnGoogleSignCover.layer.cornerRadius = Theme.appRoundness
        btnGoogleSignCover.setTitle("Sign in with Google", for: .normal)
        btnGoogleSignCover.titleLabel?.font = UIFont(name: "Eina01-Bold", size: 16)
        
        btnGoogleSignCover.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: btnGoogleSignCover.leftAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: btnGoogleSignCover.centerYAnchor).isActive = true
    }
    
    func customPointBullets() {
        pointBulletOne.textColor = Theme.primaryColor
        pointBulletTwo.textColor = Theme.primaryColor
        pointBulletThree.textColor = Theme.primaryColor
    }
    
    @objc func checkIfLoggedIn() {
        UIView.animate(withDuration: 0.3) {
            if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
                self.ifLoggedInView.alpha = 1
            } else {
                self.ifLoggedInView.alpha = 0
            }
            print("checking!")
        }
    }
}

extension LoginViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
        case 1:
            if indexPath.row == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                didTapLogout()
                print("now?")
            }
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionItems.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerBG = UIView(frame: CGRect(x: 0, y: 0, width: loginTableView.frame.width, height: 40))
        headerBG.backgroundColor = .systemBackground
        
        let sectionTitle = UILabel(frame: CGRect(x: Theme.generalPadding, y: 0, width: loginTableView.frame.width, height: 40))
        sectionTitle.textColor = .label
        labelFont(type: sectionTitle, weight: "Bold", fontSize: 24)
        
        sectionTitle.text = sectionTitles[section]
        
        headerBG.addSubview(sectionTitle)
        return headerBG
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = loginTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = actionItems[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont(name: "Eina01-Regular", size: 18)
        
        return cell
    }
}
