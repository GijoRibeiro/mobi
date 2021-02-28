//
//  AdaptiveResolution.swift
//  Devium iOS
//
//  Created by Rodrigo Ribeiro on 28.01.21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIView {

    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

struct Root: Codable {
    var posts: Posts
}

struct Posts: Codable {
    var id: Int?
    var title: String?
    var author: String?
    var cover: String?
    var likes: Int?
    var comments: Int?
}

struct Authors: Codable {
    var authorone: String?
    var authortwo: String?
}


    
