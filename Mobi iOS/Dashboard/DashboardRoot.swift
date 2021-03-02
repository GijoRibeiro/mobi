//
//  DashboardRoot.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import FirebaseDatabase
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
    
    //reusables
    let winnersCard = mainBattleController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create number of posts to show
        database.child("Post").observe(.value, with: { (snapshot) in
            let rawValue = snapshot.children
            self.numberOfPostsToShow.removeAll()
            for _ in rawValue {
                self.numberOfPostsToShow.append("Item")
                self.collectionView.reloadData()
            }
        })
        
        labelFont(type: welcomeLabelNavBar, weight: "Bold", fontSize: 32)
        welcomeLabelNavBar.text = "Explore Stories"
        welcomeLabelNavBar.textAlignment = .left
        welcomeLabelNavBar.numberOfLines = 2
        welcomeLabelNavBar.lineBreakMode = .byWordWrapping
        welcomeLabelNavBar.sizeToFit()
        profilePicNavBar.image = UIImage(named: "userImage3.png")
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
    
    @objc func trendyTapped(sender:UITapGestureRecognizer){
        print("loading...")
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
            UIView.animate(withDuration: 0.1) {
                
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
        
        database.child("Post/Post\(indexPath.row)/Likes").setValue(FirebaseDatabase.ServerValue.increment(1))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
        
        //listening to likes count
        databaseHandle = database.child("Post/Post\(indexPath.row)/Likes").observe(.value, with: { (snapshot) in
            let rawValue = snapshot.value
            
            if let passValue = rawValue {
                cell.likesLabel.text = "\(passValue)"
            } else {
                print("Error fetching likes count on cell \(indexPath.row)")
            }
        })
        
        //listening to comments count
        databaseHandle = database.child("Post/Post\(indexPath.row)/Comments").observe(.value, with: { (snapshot) in
            let rawValue = snapshot.value
            
            if let passValue = rawValue {
                cell.commentsLabel.text = "\(passValue)"
            } else {
                print("Error fetching comments count on cell \(indexPath.row)")
            }
        })
        
        //single event image cover
        database.child("Post/Post\(indexPath.row)/Cover").observeSingleEvent(of: .value, with: { (snapshot) in
            let rawValue = snapshot.value

            if let passValue = rawValue {
                cell.originalPhoto.sd_setImage(with: URL(string: "\(passValue)"), placeholderImage: UIImage(named: "Transparent.png"))
            } else {
                cell.originalPhoto.image = UIImage(named: "Transparent.png")
                print("Error fetching cover image on cell \(indexPath.row)")
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 370)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfPostsToShow.count
    }
}

extension dashboardRootVC {
    
    func fetchData(completionHandler: @escaping ([Posts]) -> Void) {
        
//        URLSession.shared.dataTask(with: mainDataURL) { (data, response, error) in
//
//            guard let data = data else {return}
//
//            do {
//                self.postsFromJson = try JSONDecoder().decode([Posts].self, from: data)
//
//                completionHandler(self.postsFromJson)
//            }
//
//            catch {
//                let error = error
//                print(error)
//            }
//        }.resume()
    }
    
    func storeChange(posts:[Posts]){
//        let encoder = JSONEncoder()
//        
//        guard let postsJSONData = try? encoder.encode(posts) else {
//            fatalError("I'm shit")
//        }
//        let postsJSON = String(data: postsJSONData, encoding: .utf8)!
//        
//        do {
//            try postsJSON.write(to: mainDataURL, atomically: true, encoding: .utf8)
//        } catch {
//            print(error)
//        }
    }
}





