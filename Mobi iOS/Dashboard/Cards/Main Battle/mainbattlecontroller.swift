//
//  mainbattlecontroller.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 21.02.21.
//

import Foundation
import UIKit

@IBDesignable
final class mainBattleController: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurateView()
    }
    
    private func configurateView() {
        guard let view = self.loadViewFromNib(nibName: "mainBattleController") else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        self.addSubview(view)
    }
    
}
