//
//  ViewController.swift
//  Devium iOS
//
//  Created by Rodrigo Ribeiro on 24.01.21.
//

import UIKit
import SwiftUI

class LoginController: UIViewController {
    
    var screenRoundness: CGFloat = 12
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        layoutSetUp()
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
    
    func configPrivacyWarning() {
        labelFont(type: privacyWarning, weight: "Regular", fontSize: 14)
        
    }
    
    func confingMailSignIn() {
        btnMailSignIn.layer.cornerRadius = screenRoundness
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
        
        btnGoogleSignIn.layer.cornerRadius = screenRoundness
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
    
    func labelFont (type: UILabel, weight: String, fontSize: CGFloat) {
        if weight == "Regular" {type.font = UIFont(name: "Eina01-Regular", size: fontSize)}
        if weight == "Bold" {type.font = UIFont(name: "Eina01-Bold", size: fontSize)}
        if weight == "Light" {type.font = UIFont(name: "Eina01-Light", size: fontSize)}
        if weight == "Semibold" {type.font = UIFont(name: "Eina01-SemiBold", size: fontSize)}
    }
    
    func fieldFont (type: UITextField, weight: String, fontSize: CGFloat) {
        if weight == "Regular" {type.font = UIFont(name: "Eina01-Regular", size: fontSize)}
        if weight == "Bold" {type.font = UIFont(name: "Eina01-Bold", size: fontSize)}
        if weight == "Light" {type.font = UIFont(name: "Eina01-Light", size: fontSize)}
        if weight == "Semibold" {type.font = UIFont(name: "Eina01-SemiBold", size: fontSize)}
    }
}
