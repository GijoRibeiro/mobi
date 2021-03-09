//
//  ViewController.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 05.03.21.
//

import UIKit
import Foundation

class DashboardTabController: UITabBarController {
    
    let backgroundView = UIView()
    let backgroundViewBlur = UIVisualEffect()
    let buttonTabOne = UIButton()
    let buttonTabTwo = UIButton()
    let buttonTabThree = UIButton()
    let mainStackView = UIStackView()
    
    let iconsSize: CGFloat = 55
    let iconsSizePadding: CGFloat = 17
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        addBackground()
        
        addHomeBtn()
        addProfileBtn()
        addSearchBtn()
        
        resizeAllViews()
        checkPageIndex()
    }
    
    @objc func didTapPageTwo() {
        print("page 2")
        self.selectedIndex = 1
        checkPageIndex()
    }
    
    @objc func didTapPageOne() {
        print("page 1")
        self.selectedIndex = 0
        checkPageIndex()
    }
    
    func setLayout() {
        self.tabBar.clipsToBounds = false
        UITabBar.setTransparentTabbar()
    }
    
    func addBackground() {
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 1, height: 40)
        backgroundView.layer.shadowRadius = 40
        backgroundView.clipsToBounds = false
        
        backgroundView.layer.borderWidth = 0.2
        backgroundView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        backgroundView.layer.cornerRadius = Theme.appRoundness
        backgroundView.backgroundColor = .systemBackground
        self.tabBar.addSubview(backgroundView)
        
        //add stackview
        mainStackView.layer.cornerRadius = Theme.appRoundness
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.spacing = 15
        backgroundView.addSubview(mainStackView)
        
    }
    
    func addHomeBtn() {
        buttonTabOne.imageEdgeInsets = UIEdgeInsets(top: iconsSizePadding, left: iconsSizePadding, bottom: iconsSizePadding, right: iconsSizePadding)
        buttonTabOne.setImage(UIImage(named: "home"), for: .normal)
        buttonTabOne.addTarget(self, action: #selector(didTapPageOne), for: .touchUpInside)
        mainStackView.addArrangedSubview(buttonTabOne)
        
        buttonTabOne.heightAnchor.constraint(equalToConstant: iconsSize).isActive = true
        buttonTabOne.widthAnchor.constraint(equalToConstant: iconsSize).isActive = true
    }
    
    func addProfileBtn() {
        buttonTabTwo.imageEdgeInsets = UIEdgeInsets(top: iconsSizePadding, left: iconsSizePadding, bottom: iconsSizePadding, right: iconsSizePadding)
        buttonTabTwo.setImage(UIImage(named: "dashboard2.png"), for: .normal)
        buttonTabTwo.addTarget(self, action: #selector(didTapPageTwo), for: .touchUpInside)
        mainStackView.addArrangedSubview(buttonTabTwo)
        
        buttonTabTwo.heightAnchor.constraint(equalToConstant: iconsSize).isActive = true
        buttonTabTwo.widthAnchor.constraint(equalToConstant: iconsSize).isActive = true
    }
    
    func addSearchBtn() {
        buttonTabThree.imageEdgeInsets = UIEdgeInsets(top: iconsSizePadding, left: iconsSizePadding, bottom: iconsSizePadding, right: iconsSizePadding)
        buttonTabThree.setImage(UIImage(named: "search.png"), for: .normal)
//        buttonTabThree.addTarget(self, action: #selector(didTapPageTwo), for: .touchUpInside)
        mainStackView.addArrangedSubview(buttonTabThree)
        
        buttonTabThree.heightAnchor.constraint(equalToConstant: iconsSize).isActive = true
        buttonTabThree.widthAnchor.constraint(equalToConstant: iconsSize).isActive = true
    }
    
    func resizeAllViews() {
        var finalWidth: CGFloat = 0
        for _ in mainStackView.arrangedSubviews {
            finalWidth += 80
        }
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width - 35, height: self.tabBar.frame.height + 5)
        backgroundView.frame.size = CGSize(width: finalWidth + 60, height: backgroundView.frame.height)
        backgroundView.center.x = self.tabBar.center.x
        
        mainStackView.widthAnchor.constraint(equalToConstant: finalWidth).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        print(finalWidth)
    }
    
    func checkPageIndex() {

        let whatPage = self.selectedIndex

        switch whatPage {
        case 0:
            buttonTabOne.setImage(UIImage(named: "home-selected"), for: .normal)
            buttonTabTwo.setImage(UIImage(named: "profile"), for: .normal)
            
            changeIconColor(btn: buttonTabOne, toColor: Theme.primaryColor)
            changeIconColor(btn: buttonTabTwo, toColor: .label)
        case 1:
            buttonTabOne.setImage(UIImage(named: "home"), for: .normal)
            buttonTabTwo.setImage(UIImage(named: "profile-selected"), for: .normal)
            
            changeIconColor(btn: buttonTabOne, toColor: .label)
            changeIconColor(btn: buttonTabTwo, toColor: Theme.primaryColor)
        case _ where whatPage > 10:
            buttonTabOne.setImage(UIImage(named: "home-selected"), for: .normal)
            buttonTabTwo.setImage(UIImage(named: "profile"), for: .normal)
            
            changeIconColor(btn: buttonTabOne, toColor: Theme.primaryColor)
            changeIconColor(btn: buttonTabTwo, toColor: .label)
        default:
            print("switch default")
        }
    }
    
    func changeIconColor(btn: UIButton, toColor: UIColor) {
        let origImage = btn.currentImage
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = toColor
    }
}

extension UITabBar {
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
    }
}
