//
//  UpdateSlides.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import Foundation
import UIKit

extension OnboardingController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //fetch sizes after orientation change
        DispatchQueue.main.async { [self] in
            
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                
            } else {
                print("Portrait")
            }
            
            setSlides()
        }
    }
    
    func setPageDots() {
        pageDots.currentPageIndicatorTintColor = Theme.primaryColor
    }
    
    func showPermissionButton() {
        let page = slidesScrollViews.contentOffset.x / slidesScrollViews.frame.size.width
         
        if page == 1 && defaults.bool(forKey: "First Launch") == false {
            btnAskPermission.isHidden = false
        } else {
            btnAskPermission.isHidden = true
        }
    }
    
    func dectectSlidePage() {
        let page = slidesScrollViews.contentOffset.x / slidesScrollViews.frame.size.width
        
        if page == 2 {
            btnNext.backgroundColor = Theme.primaryColor
        } else {
            btnNext.backgroundColor = .black
        }
    }
    
    func nextPageSlide() {
        let page = slidesScrollViews.contentOffset.x / slidesScrollViews.frame.size.width
        
        scrollToPage(page: Int(page) + 1, animated: true)
    }
}
