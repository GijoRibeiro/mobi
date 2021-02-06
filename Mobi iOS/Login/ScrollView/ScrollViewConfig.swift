//
//  ScrollViewConfig.swift
//  Devium iOS
//
//  Created by Rodrigo Ribeiro on 27.01.21.
//

import UIKit

extension LoginController: UIScrollViewDelegate {

    func configSliders() {
        
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        mainStackView.layoutIfNeeded()
        introView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: (introView.frame.width * CGFloat(3)), height: introView.frame.height)

        let mainText: [String] = ["You're probably bummed out by 80's teachers.","What?! They don't even have phones?","Our mentors are inside the matrix. You're safe with us."]
        let textColor: [UIColor] = [.black,.black, primaryColor]

        for x in 0..<3 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * introView.frame.width, y: 0, width: introView.frame.width, height: introView.frame.height))

            addMainTitle(yourView: page, text: mainText[x], color: textColor[x])
            
            scrollView.addSubview(page)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDots.currentPage = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
    }
}

