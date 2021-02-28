//
//  mainbattlecontroller.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 21.02.21.
//

import Foundation
import UIKit
import SDWebImage

@IBDesignable
final class mainBattleController: UIView {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var bgImageBlur: UIImageView!
    @IBOutlet weak var fadeImage: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurateView()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        
        self.mainImage.layer.cornerRadius = 12
        
        fadeImage.layer.cornerRadius = 12
        
    }
    
    private func configurateView() {
        guard let view = self.loadViewFromNib(nibName: "mainBattleController") else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        self.addSubview(view)
    }
    
}
