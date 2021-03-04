//
//  TopCollectionViewCell.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 10.02.21.
//

import UIKit
import SkeletonView
import FirebaseDatabase
import FirebaseAuth

class TopCollectionViewCell: UICollectionViewCell {
    
    let database = Database.database().reference()
    
    @IBOutlet weak var originalPhoto: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var blackFade: UIView!
    @IBOutlet weak var mainTag: UILabel!
    @IBOutlet weak var bottomContainer: UIVisualEffectView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var heartIcon: UIButton!
    
    var postLiked = Bool()
    var indexPathFromVC = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPhotoFade()
        
        bottomContainer.layer.cornerRadius = appRoundness
        bottomContainer.clipsToBounds = true
        
        loadingView.layer.cornerRadius = appRoundness
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
    
    @IBAction func didTapLike(_ sender: Any) {
        
        if postLiked == true {
            print("Disliking post")
            
            //check if the post is already liked
            postLiked = false
            
            //change icon
            dislikeHeart()
            
            //increment like
            database.child("Post/Post\(indexPathFromVC)/Likes").setValue(FirebaseDatabase.ServerValue.increment(-1))
            
            //get user id
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            //remove user from inside's post liked data
            database.child("Post/Post\(indexPathFromVC)/LikedBy").child(userID).removeValue()
            
        } else {
            print("You liked post \(indexPathFromVC)")
            
            postLiked = true
            
            //change icon
            fillHeart()
            
            //increment like
            database.child("Post/Post\(indexPathFromVC)/Likes").setValue(FirebaseDatabase.ServerValue.increment(1))
            
            //get user id
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            //add user inside's post liked data
            database.child("Post/Post\(indexPathFromVC)/LikedBy").child(userID).setValue("Liked")
        }
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
    
    func incrementLike(indexPath: IndexPath) {
        database.child("Post/Post\(indexPathFromVC)/Likes").setValue(FirebaseDatabase.ServerValue.increment(1))
    }
    
    func fillHeart() {
        heartIcon.tintColor = .red
        heartIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    func dislikeHeart() {
        heartIcon.tintColor = .label
        heartIcon.setImage(UIImage(systemName: "heart"), for: .normal)
    }

}
