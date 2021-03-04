//
//  DashboardRootNC.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import Foundation
import UIKit

class dashboardRootNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
        
        self.view.addSubview(statusBarView)
        statusBarView.backgroundColor = .systemBackground
    }
    
    func setFonts() {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Eina01-Bold", size: 16)!]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Eina01-Bold", size: 32)!]
    }
}
