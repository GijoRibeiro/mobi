//
//  ViewController.swift
//  Devium iOS
//
//  Created by Rodrigo Ribeiro on 24.01.21.
//

import UIKit
import SwiftUI

class LoginController: UIViewController {
    
    @IBOutlet var btnGoogleSignIn: UIButton!
    @IBOutlet var btnMailSignIn: UIButton!
    @IBOutlet var privacyWarning: UILabel!
    @IBOutlet var logo: UIImageView!
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageDots: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        layoutSetUp()
        userAlreadyLoggedIn()
    }
}

// MARK: - Portrait Layout
extension LoginController {
    
    func layoutSetUp() {
        
        confingMailSignIn()
        configPrivacyWarning()
        confingGoogleSignIn()
        configSliders()
    }
    
    func userAlreadyLoggedIn() {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "dashboardTC")
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    func configPrivacyWarning() {
        labelFont(type: privacyWarning, weight: "Regular", fontSize: 14)
        
    }
    
    func confingMailSignIn() {
        btnMailSignIn.layer.cornerRadius = Theme.appRoundness
        btnMailSignIn.translatesAutoresizingMaskIntoConstraints = false
        btnMailSignIn.setTitle("Got it...again", for: .normal)
        btnMailSignIn.layer.borderWidth = 0.5
        btnMailSignIn.backgroundColor = .white
        btnMailSignIn.layer.borderColor = UIColor.black.cgColor
        btnMailSignIn.titleLabel?.font = UIFont(name: "Eina01-Bold", size: 16)
    }
    
    func confingGoogleSignIn() {
        let googleLogo = "google.png"
        let image = UIImage(named: googleLogo)
        let imageView = UIImageView(image: image!)
        
        btnGoogleSignIn.layer.cornerRadius = Theme.appRoundness
        btnGoogleSignIn.setTitle("Sign in with Google", for: .normal)
        btnGoogleSignIn.titleLabel?.font = UIFont(name: "Eina01-Bold", size: 16)
        
        btnGoogleSignIn.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: btnGoogleSignIn.leftAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: btnGoogleSignIn.centerYAnchor).isActive = true
    }
}

//MARK: - Helpers
extension LoginController {
    
    func addMainTitle(yourView: UIView, text: String, color: UIColor) {
        let width = scrollView.frame.width / 1.1
        let height = scrollView.frame.height
        let fontSize = 32
        let mainLabel: UILabel = UILabel()
        
        mainLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
        mainLabel.font = UIFont(name: "Eina01-Bold", size: CGFloat(fontSize))
        mainLabel.text = text
        labelFont(type: mainLabel, weight: "Bold", fontSize: 32)
        mainLabel.numberOfLines = 3
        mainLabel.adjustsFontSizeToFitWidth = true
        mainLabel.textColor = color
        yourView.addSubview(mainLabel)
    }
}
