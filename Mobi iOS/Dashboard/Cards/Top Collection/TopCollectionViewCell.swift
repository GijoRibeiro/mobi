//
//  TopCollectionViewCell.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 10.02.21.
//

import UIKit
import SkeletonView
import FirebaseDatabase

class TopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalPhoto: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var blackFade: UIView!
    @IBOutlet weak var mainTag: UILabel!
    @IBOutlet weak var bottomContainer: UIVisualEffectView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPhotoFade()
        
        bottomContainer.layer.cornerRadius = 20
        bottomContainer.clipsToBounds = true
        
        loadingView.layer.cornerRadius = 20
        loadingView.layer.masksToBounds = true
        loadingView.isSkeletonable = true
        loadingView.showAnimatedGradientSkeleton()

        originalPhoto.layer.cornerRadius = appRoundness
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = appRoundness
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 5, height: 8)
        self.layer.masksToBounds = false
    }
    
    public func addOriginalPhoto(photo: UIImage) {
        originalPhoto.image = photo
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TopCollectionViewCell", bundle: nil)
    }
    
    func addPhotoFade() {
        blackFade.backgroundColor = .black
        blackFade.clipsToBounds = true
        blackFade.layer.cornerRadius = appRoundness
        blackFade.alpha = 0.2
    }

}
