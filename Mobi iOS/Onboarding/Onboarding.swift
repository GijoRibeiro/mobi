//
//  Onboarding.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 06.02.21.
//

import UIKit
import SwiftUI
import Photos

class OnboardingController: UIViewController, UIScrollViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var btnAskPermission: UIButton!
    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var slidesScrollViews: UIScrollView!
    @IBOutlet weak var btnNext: UIButton!
    
    let screenRoundness = CGFloat(16)
    let photos = PHPhotoLibrary.authorizationStatus()
    var weAskedForPermission : Bool!
    
    let textColor: [UIColor] = [.black,.black, primaryColor]
    let mainTitleText: [String] = ["Look at you...","Ok, let me see","End up cooler",]
    let subText: [String] = ["Lisen, we are the people who care about your growth.","We will analyse all your media to choose what's best to post.","Posting our recommendations will make you stand out in the crowd trends - unlike Pewdiepie.",]
    let images: [UIImage] = [
        UIImage(named: "yourgrowth2.png")!,
        UIImage(named: "mediaanalyse.png")!,
        UIImage(named: "cooler.png")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slidesScrollViews.delegate = self
        
        setSlides()
        setPageDots()
        addBtnNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if defaults.bool(forKey: "First Launch") == true {
            print("NOPE! not first access.")
        } else {
            print("This is user's first access.")
        }
    }
    
    @IBAction func actionAskPermission(_ sender: Any) {
        if defaults.bool(forKey: "First Launch") == false {
            PHPhotoLibrary.requestAuthorization { (status) in}
            defaults.set(true, forKey: "First Launch")
            btnAskPermission.isHidden = true
        }
    }
    
    func setSlides() {
        
        for view in slidesScrollViews.subviews {
            view.removeFromSuperview()
        }
        
        slidesScrollViews.contentSize = CGSize(width: containerView.frame.width * 3, height: containerView.frame.height - 10)
        
        for x in 0..<3 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * slidesScrollViews.frame.width, y: 0, width: slidesScrollViews.frame.width, height: slidesScrollViews.frame.height))
            
            addImageSet(yourView: page, image: images[x])
            addMainTitle(yourView: page, text: mainTitleText[x], color: textColor[x])
            addSubTitle(yourView: page, text: subText[x], color: textColor[x])
            
            slidesScrollViews.addSubview(page)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDots.currentPage = Int(floorf(Float(slidesScrollViews.contentOffset.x / slidesScrollViews.frame.size.width)))
        
        dectectSlidePage()
        showPermissionButton()
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        
        if btnNext.backgroundColor == primaryColor {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "dashboardTC")
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
        } else {
            nextPageSlide()
        }
    }
}

extension OnboardingController {
    
    func addMainTitle(yourView: UIView, text: String, color: UIColor){
        let width = yourView.frame.width - 32
        let height = 60
        let fontSize = 32
        let mainLabel: UILabel = UILabel()
        
        mainLabel.frame = CGRect(x: CGFloat(Int(yourView.frame.width)) / 2 - (width / 2), y: 0, width: width, height: CGFloat(height))
        mainLabel.center.y = yourView.frame.height / 1.35
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "Eina01-Bold", size: CGFloat(fontSize))
        mainLabel.backgroundColor = .systemBackground
        mainLabel.text = text
        labelFont(type: mainLabel, weight: "Bold", fontSize: CGFloat(fontSize))
        mainLabel.numberOfLines = 3
        mainLabel.adjustsFontSizeToFitWidth = true
        mainLabel.textColor = color
        yourView.addSubview(mainLabel)
    }
    
    func addSubTitle(yourView: UIView, text: String, color: UIColor){
        let width = yourView.frame.width - 62
        let height = 80
        let fontSize = 16
        let mainLabel: UILabel = UILabel()
        
        mainLabel.frame = CGRect(x: CGFloat(Int(yourView.frame.width)) / 2 - (width / 2), y: 0, width: width, height: CGFloat(height))
        mainLabel.center.y = yourView.frame.height / 1.15
        mainLabel.font = UIFont(name: "Eina01-Bold", size: CGFloat(fontSize))
        mainLabel.text = text
        mainLabel.textAlignment = .center
        labelFont(type: mainLabel, weight: "Regular", fontSize: CGFloat(fontSize))
        mainLabel.numberOfLines = 3
        mainLabel.adjustsFontSizeToFitWidth = true
        mainLabel.textColor = color
        yourView.addSubview(mainLabel)
    }
    
    func addImageSet(yourView: UIView, image: UIImage){
        let width = yourView.frame.width
        let height = yourView.frame.height / 1.6
        let imageView: UIImageView = UIImageView()
        
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: CGFloat(Int(yourView.frame.width)) / 2 - (width / 2), y: 0, width: width, height: height)
        imageView.center.y = yourView.frame.height / 2.8
        imageView.image = image
        
        yourView.addSubview(imageView)
    }
}

extension OnboardingController {
    
    func addBtnNext() {
        btnNext.layer.cornerRadius = appRoundness
        btnNext.titleLabel?.font = UIFont(name: "Eina01-Bold", size: 16)
        btnNext.semanticContentAttribute = .forceRightToLeft
        
        btnAskPermission.layer.cornerRadius = appRoundness
        btnAskPermission.layer.borderWidth = 0.5
        btnAskPermission.backgroundColor = .white
        btnAskPermission.layer.borderColor = UIColor.black.cgColor
        btnAskPermission.titleLabel?.font = UIFont(name: "Eina01-Bold", size: 16)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.slidesScrollViews.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.slidesScrollViews.scrollRectToVisible(frame, animated: animated)
    }
    
}
