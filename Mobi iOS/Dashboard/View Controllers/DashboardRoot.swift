//
//  DashboardRoot.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import SDWebImage
import UIKit

class dashboardRootVC: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mainViewContainer: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var insideScrollViewContainer: UIView!
    @IBOutlet weak var trendyLabel: UILabel!
    @IBOutlet weak var topPhotosLabel: UILabel!
    @IBOutlet weak var postTodayLabel: UILabel!
    @IBOutlet weak var containerBeforeAfterShadow: UIImageView!
    @IBOutlet weak var containerBeforeAfter: UIView!
    @IBOutlet weak var afterPhoto: UIImageView!
    @IBOutlet weak var beforePhoto: UIImageView!
    @IBOutlet weak var winner1: mainBattleController!
    @IBOutlet weak var winner2: mainBattleController!
    
    let database = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    //navbar layout
    let customNavBarPro = UIView()
    let profilePicNavBar = UIImageView()
    let welcomeLabelNavBar = UILabel()
    let notificationBell = UIImageView()
    var numberOfPostsToShow = [String]()
    var numberOfPostsToShowInt = Int()
    
    //content
    var dataWasFetched = false
    let loadingIndicator = UIActivityIndicatorView()
    var images:[String] = []
    var imagesWithFaces:[UIImage] = []
    var imagesToPost:[UIImage] = []
    var mainTags: [String] = ["Nerdy", "Playful", "Joy", "Tech", "Musician", "Retro"]
    
    //photo
    let titleLabel : UILabel = UILabel()
    let subTitleLabel : UILabel = UILabel()
    
    
    var dataPostToRetrieve = [PostToRetrieve]()
    
    //stored user details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchData()
        
        
        labelFont(type: welcomeLabelNavBar, weight: "Bold", fontSize: 32)
        welcomeLabelNavBar.text = "Explore Stories"
        welcomeLabelNavBar.textAlignment = .left
        welcomeLabelNavBar.numberOfLines = 2
        welcomeLabelNavBar.lineBreakMode = .byWordWrapping
        welcomeLabelNavBar.sizeToFit()
        
        profilePicNavBar.layer.cornerRadius = 16
        profilePicNavBar.clipsToBounds = true
        
        self.navigationController?.navigationBar.addSubview(customNavBarPro)
        self.navigationController?.navigationBar.addSubview(welcomeLabelNavBar)
        self.navigationController?.navigationBar.addSubview(profilePicNavBar)
        
        setLayout()
        
        // nav bar
        setNavSubTitle()
        
        self.navigationController?.navigationBar.layoutMargins.left = 20
        self.navigationController?.navigationBar.layoutMargins.right = 20
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        minimizeNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userURL = UserDefaults.standard.string(forKey: "UserPhotoURL")
        if userURL != nil {
            let userPhotoURL = userURL!
            profilePicNavBar.sd_setImage(with: URL(string: "\(userPhotoURL)"), placeholderImage: UIImage(named: "Transparent.png"))
            print(userPhotoURL)
        } else {
            print("no one is logged in :(")
            profilePicNavBar.image = UIImage(named: "userImage3")
        }
    }
    
    @objc func trendyTapped(sender:UITapGestureRecognizer){
        print("loading...")
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
            let x = serverTimestamp / 1000
            let date = NSDate(timeIntervalSince1970: x)
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium

            return formatter.string(from: date as Date)
    }
    
    func fetchData() {
        
        self.dataPostToRetrieve.removeAll()
        
        //create number of posts to show
//        database.child("Post").observe(.childAdded) { (snapshot) in
        database.child("Post").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let key = snapshot.key
                let likes = dict["Likes"] as? Int
                let likedBy = dict["LikedBy"] as? [String: Any]
                let comments = dict["Comments"] as? Int
                let cover = dict["Cover"] as? String
                let author = dict["Author"] as? String
                let title = dict["Title"] as? String
                let authorPhoto = dict["AuthorPhotoURL"] as? String
                let createdAt = dict["timestamp"] as? Double
                
                let post = PostToRetrieve(likesCount: likes ?? 0,
                                          commentsCount: comments ?? 0,
                                          CoverURL: cover ?? "No Image",
                                          LikedByList: likedBy ?? ["Nil": "Nil"],
                                          PostIDKey: key,
                                          AuthorName: author ?? "Error retrieving",
                                          TitleName: title ?? "Error retrieving",
                                          AuthorPhotoURL: authorPhoto ?? "No author photo",
                                          setCreatedAt: createdAt ?? 0.0)
                
                self.dataPostToRetrieve.append(post)
                self.collectionView.reloadData()
                self.dataPostToRetrieve.sort(by: {$0.createdAt > $1.createdAt})
                print(post.createdAt)
            }
        }
        

    }
}

//Scroll view
extension dashboardRootVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        minimizeNavBar()
    }
    
    func minimizeNavBar() {
        
        let expandedTitleHeight: CGFloat = 80
        let expandedTitleWidth: CGFloat = 300
        let expandedNavBarHeight: CGFloat = 120
        let notificationBellSize: CGFloat = 42
        
        if (self.navigationController?.navigationBar.frame.height)! > 80 {
            //            expanded
            UIView.animate(withDuration: 0.1) {
                
                self.customNavBarPro.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: 210)
                self.customNavBarPro.backgroundColor = .systemBackground
                self.welcomeLabelNavBar.textColor = .label
                self.customNavBarPro.layer.shadowOpacity = 0.0
                
                //limit expansion
                if (self.navigationController?.navigationBar.frame.height)! >= expandedNavBarHeight {
                    self.welcomeLabelNavBar.frame = CGRect(x: 20, y: expandedNavBarHeight / 0.6, width: expandedTitleWidth, height: expandedTitleHeight)
                } else {
                    self.welcomeLabelNavBar.frame = CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! / 0.6, width: expandedTitleWidth, height: expandedTitleHeight)
                }
                labelFont(type: self.welcomeLabelNavBar, weight: "Bold", fontSize: 28)
                
                self.profilePicNavBar.alpha = 1.0
                self.profilePicNavBar.frame = CGRect(x: 20, y: 30, width: 60, height: 60)
                
                self.subTitleLabel.alpha = 1
                self.subTitleLabel.frame = CGRect(x: 20, y: self.welcomeLabelNavBar.frame.minY - 12 , width: 200, height: 40)
                
                self.notificationBell.frame = CGRect(x: (self.navigationController?.navigationBar.frame.width)! - notificationBellSize - 20, y: 0, width: notificationBellSize, height: notificationBellSize)
                self.notificationBell.center.y = self.profilePicNavBar.center.y
                self.notificationBell.alpha = 0.7
                self.notificationBell.image = UIImage(named: "bellwithFrame2.png")
            }
            
            // ends expanded
            
        } else {
            
            // minimzed
            UIView.animate(withDuration: 0.3) {
                
                self.customNavBarPro.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)! + 10)
                self.customNavBarPro.backgroundColor = .systemBackground
                self.customNavBarPro.layer.shadowColor = UIColor.black.cgColor
                self.customNavBarPro.layer.shadowOffset = CGSize(width: 0, height: 24)
                self.customNavBarPro.layer.shadowRadius = 12
                self.customNavBarPro.layer.shadowOpacity = 0
                
                self.subTitleLabel.alpha = 0.0
                
                labelFont(type: self.welcomeLabelNavBar, weight: "Bold", fontSize: 18)
                self.welcomeLabelNavBar.textColor = .label
                self.welcomeLabelNavBar.frame = CGRect(x: 20, y: 0, width: 200, height: (self.navigationController?.navigationBar.frame.height)! + 10)
                
                self.profilePicNavBar.alpha = 0.0
                self.profilePicNavBar.frame = CGRect(x: 20, y: self.welcomeLabelNavBar.frame.minY - 20, width: 60, height: 60)
                self.profilePicNavBar.alpha = 0.0
                
                self.notificationBell.image = UIImage(named: "BellWithoutFrame")
                self.notificationBell.frame = CGRect(x: (self.navigationController?.navigationBar.frame.width)! - 20 - 30, y: 0, width: 20, height: 20)
                self.notificationBell.center.y = self.customNavBarPro.center.y
                self.notificationBell.alpha = 0.6
            }
        }
    }
    
    func setNavSubTitle() {
        subTitleLabel.text = "Welcome, Gijo"
        subTitleLabel.textColor = .gray
        subTitleLabel.textAlignment = .left
        labelFont(type: subTitleLabel, weight: "Regular", fontSize: 16)
        
        self.navigationController?.navigationBar.addSubview(subTitleLabel)
        
        notificationBell.image = UIImage(named: "bellwithFrame2.png")
        notificationBell.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.addSubview(notificationBell)
    }
}

extension dashboardRootVC {
    
    func setLayout() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCollectionViewCell.nib(), forCellWithReuseIdentifier: "TopCollectionViewCell")
    }
}

//Collection View
extension dashboardRootVC {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //        let cell = collectionView.cellForItem(at: indexPath) as! TopCollectionViewCell
        //        database.child("Post/Post\(indexPath.row)/Likes").setValue(FirebaseDatabase.ServerValue.increment(1))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
        
        cell.postID = "\(dataPostToRetrieve[indexPath.row].PostID)"
        cell.commentsLabel.text = "\(dataPostToRetrieve[indexPath.row].Comments)"
        
        //main title
        cell.postTitle.text = "\(dataPostToRetrieve[indexPath.row].Title)"
        
        //author
        cell.authorName.text = "\(dataPostToRetrieve[indexPath.row].Author)"
        
        //author photo
        cell.authorPhoto.sd_setImage(with: URL(string: "\(dataPostToRetrieve[indexPath.row].AuthorPhoto)"), placeholderImage: UIImage(named: "Transparent.png"))
        
        //post photo
        cell.originalPhoto.sd_setImage(with: URL(string: "\(dataPostToRetrieve[indexPath.row].Cover)"), placeholderImage: UIImage(named: "Transparent.png"))
        
        //fill the heart if liked
        database.child("Post/\(dataPostToRetrieve[indexPath.row].PostID)/LikedBy").observeSingleEvent(of: .value) { (snapshot) in
            
            if let userID: String = Auth.auth().currentUser?.uid {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    
                    if key == userID {
                        cell.fillHeart()
                    }
                }
            }
            
            //always update like count regardless of result
            cell.updateLikeCount()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                cell.bottomContainer.alpha = 1
                cell.iconsStackView.alpha = 1
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 370)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataPostToRetrieve.count
    }
    
}

class PostToRetrieve {
    var Likes: Int
    var Comments: Int
    var Cover: String
    var LikedBy: [String: Any]
    var PostID: String
    var Author: String
    var AuthorPhoto: String
    var Title: String
    var createdAt: Double
    
    init(likesCount: Int, commentsCount: Int, CoverURL: String, LikedByList: [String: Any], PostIDKey: String, AuthorName: String, TitleName: String, AuthorPhotoURL: String, setCreatedAt: Double) {
        Likes = likesCount
        Comments = commentsCount
        Cover = CoverURL
        PostID = PostIDKey
        LikedBy = LikedByList
        Author = "by \(AuthorName)"
        Title = TitleName
        AuthorPhoto = AuthorPhotoURL
        createdAt = setCreatedAt
    }
}

struct PostToCreate {
    var Cover: String
    var Author: String
    var AuthorPhoto: String
    var Title: String
    
    init(CoverURL: String, AuthorName: String, TitleName: String, AuthorPhotoURL: String) {
        Cover = CoverURL
        Author = "by \(AuthorName)"
        Title = TitleName
        AuthorPhoto = AuthorPhotoURL
    }
}
