//
//  DashboardRoot.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import Foundation
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import SDWebImage
import UIKit

class dashboardRootVC: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mainViewContainer: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var insideScrollViewContainer: UIView!
    @IBOutlet weak var trendImageContainer: UIView!
    @IBOutlet weak var trendImage: UIImageView!
    @IBOutlet weak var trendyLabel: UILabel!
    @IBOutlet weak var topPhotosLabel: UILabel!
    @IBOutlet weak var blurShadow: UIImageView!
    @IBOutlet weak var postTodayLabel: UILabel!
    @IBOutlet weak var customNavBar: UIView!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBeforeAfterShadow: UIImageView!
    @IBOutlet weak var containerBeforeAfter: UIView!
    @IBOutlet weak var afterPhoto: UIImageView!
    @IBOutlet weak var beforePhoto: UIImageView!
    
    var lastContentOffset: CGFloat = 0
    
    //navbar layout
    var customNavBarPro = UIView()
    var profilePicNavBar = UIImageView()
    var welcomeLabelNavBar = UILabel()
    
    let loadingIndicator = UIActivityIndicatorView()
    var images:[UIImage] = []
    var imagesWithFaces:[UIImage] = []
    var imagesToPost:[UIImage] = []
    var mainTags: [String] = ["Nerdy", "Playful", "Joy", "Tech", "Musician", "Retro"]
    
    let filterContext = CIContext()
    
    let trendImageUrl = "https://source.unsplash.com/random"
    let fileUrl = URL(string: "https://source.unsplash.com/featured/?film")
    let faceUrl = URL(string: "https://source.unsplash.com/featured/?face")
    let titleLabel : UILabel = UILabel()
    let subTitleLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabelNavBar.text = "Large Title"
        welcomeLabelNavBar.textColor = .black
        welcomeLabelNavBar.textAlignment = .left
        welcomeLabelNavBar.frame = CGRect(x: 20, y: 75, width: 200, height: 40)
        labelFont(type: welcomeLabelNavBar, weight: "Bold", fontSize: 32)
        
        profilePicNavBar.image = UIImage(named: "userImage3.png")
        profilePicNavBar.layer.cornerRadius = 16
        profilePicNavBar.clipsToBounds = true
        
        self.navigationController?.navigationBar.addSubview(customNavBarPro)
        self.navigationController?.navigationBar.addSubview(welcomeLabelNavBar)
        self.navigationController?.navigationBar.addSubview(profilePicNavBar)
        
        minimizeNavBar()
        
        mainViewContainer.delegate = self
        
        setLayout()
        fetchPhotos()
        addTrendyImage()
        postTodayLayout()
        
        // nav bar
        setNavSubTitle()
        
        // fetch photos
        selectFacePhotos(runAfterLoop: addPostTodayPhotos)
        
        self.navigationController?.navigationBar.layoutMargins.left = 20
        self.navigationController?.navigationBar.layoutMargins.right = 20
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateScrollViewWhenRotating()
    }
    
    @objc func trendyTapped(sender:UITapGestureRecognizer){
        print("loading...")
    }
    
    func searchForFace(photo: UIImageView) {
        
        if let inputImage = photo.image {
            let ciImage = CIImage(cgImage: inputImage.cgImage!)
            
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
            
            let faces = faceDetector.features(in: ciImage)
            
            if let face = faces.first as? CIFaceFeature {
                print("Found face at \(face.bounds)")
                
                let faceBox:UIView = UIView()
                faceBox.frame = CGRect(x: 0, y: 0, width: face.bounds.width, height: face.bounds.height)
                faceBox.layer.borderWidth = 3
                faceBox.layer.borderColor = UIColor.red.cgColor
                photo.addSubview(faceBox)
            }
        }
    }
    
    func searchForFaceImage(photo: UIImage) -> Bool {
        
        let ciImage = CIImage(cgImage: photo.cgImage!)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        
        let faces = faceDetector.features(in: ciImage)
        
        for _ in faces {
            print("Found a face! Adding to the face folder.")
            return true
        }
        return false
    }
    
    func selectFacePhotos(runAfterLoop: () -> ()) {
        
        beforePhoto.sd_setImage(with: faceUrl, placeholderImage: UIImage(named: "placeholder.png"))
        
        for element in imagesToPost {
            if searchForFaceImage(photo: element) == true {
                imagesWithFaces += [element]
            }
        }
        runAfterLoop()
    }
    
    func addPostTodayPhotos() {
        beforePhoto.image = imagesWithFaces.randomElement()
        afterPhoto.image = imagesWithFaces.randomElement()
        print("FINALLY")
    }
    
    func updateAfterPhotoWithFilter() {
        
        if let currentFilter = CIFilter(name: "CIPhotoEffectProcess") {
            let beginImage = CIImage(image: beforePhoto.image!)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            //            currentFilter.setValue(1, forKey: kCIInputIntensityKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = filterContext.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    afterPhoto.image = processedImage
                }
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
        
        if (self.navigationController?.navigationBar.frame.height)! > 80 {
            UIView.animate(withDuration: 0.4) {
                self.subTitleLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.subTitleLabel.alpha = 0.0
            }
        }
        
        if (self.navigationController?.navigationBar.frame.height)! > 80 {
            UIView.animate(withDuration: 0.2) {
//                expanded
                self.customNavBarPro.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: 210)
                self.customNavBarPro.backgroundColor = .white
                self.customNavBarPro.layer.shadowOpacity = 0.0
                
                self.welcomeLabelNavBar.frame = CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! / 0.6, width: 200, height: 40)
                labelFont(type: self.welcomeLabelNavBar, weight: "Bold", fontSize: 32)
                
                self.profilePicNavBar.alpha = 1.0
                self.profilePicNavBar.frame = CGRect(x: 20, y: self.welcomeLabelNavBar.frame.minY - self.welcomeLabelNavBar.frame.height - 60 , width: 60, height: 60)
            }
        } else {
//            minimized
            UIView.animate(withDuration: 0.2) {
                
                self.customNavBarPro.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: 65)
                self.customNavBarPro.backgroundColor = .white
                self.customNavBarPro.layer.shadowColor = UIColor.black.cgColor
                self.customNavBarPro.layer.shadowOpacity = 0.05
                self.customNavBarPro.layer.shadowOffset = CGSize(width: 0, height: 24)
                self.customNavBarPro.layer.shadowRadius = 12
                
                self.profilePicNavBar.alpha = 0.0
                
                labelFont(type: self.welcomeLabelNavBar, weight: "Bold", fontSize: 24)
                self.welcomeLabelNavBar.frame = CGRect(x: 20, y: (self.navigationController?.navigationBar.frame.height)! / 2.4, width: 200, height: 40)
                
            }
        }
    }
    
    func setNavSubTitle() {
        subTitleLabel.text = "Welcome, Gijo"
        subTitleLabel.textColor = .gray
        subTitleLabel.textAlignment = .left
        subTitleLabel.frame = CGRect(x: 20, y: 10, width: 200, height: 40)
        labelFont(type: subTitleLabel, weight: "Regular", fontSize: 16)
        
        
        
        self.navigationController?.navigationBar.addSubview(subTitleLabel)
    }
}

extension dashboardRootVC {
    
    func setLayout() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TopCollectionViewCell.nib(), forCellWithReuseIdentifier: "TopCollectionViewCell")
        
        labelFont(type: topPhotosLabel, weight: "Bold", fontSize: 20)
        labelFont(type: trendyLabel, weight: "Bold", fontSize: 20)
        labelFont(type: postTodayLabel, weight: "Bold", fontSize: 20)
    }
    
    func addTrendyImage() {
        
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.trendyTapped(sender:)))
//        trendImage.addGestureRecognizer(tapGR)
//        trendImage.isUserInteractionEnabled = true
//
//        //container
//        trendImageContainer.backgroundColor = supportColor
//        trendImageContainer.layer.cornerRadius = appRoundness
//        trendImageContainer.clipsToBounds = true
//
//        //pic
//        trendImage.clipsToBounds = true
//        trendImage.layer.cornerRadius = appRoundness
//
//        //fetch
//        trendImage.load(url: fileUrl!)
//        blurShadow.load(url: fileUrl!)
    }
    
    func postTodayLayout() {
        
        //container
        containerBeforeAfter.backgroundColor = supportColor
        containerBeforeAfter.layer.cornerRadius = appRoundness
        containerBeforeAfter.clipsToBounds = true
        
        //before pic
        beforePhoto.clipsToBounds = true
        beforePhoto.layer.cornerRadius = appRoundness
        
        //after pic
        afterPhoto.clipsToBounds = true
        afterPhoto.layer.cornerRadius = appRoundness
    }
    
    func updateScrollViewWhenRotating() {
        
        // container inside scrollview
        var height:CGFloat = 0
        for view in self.insideScrollViewContainer.subviews {
            height = height + view.bounds.size.height + 24
        }
        
        self.mainViewContainer.contentSize = CGSize(width: self.mainViewContainer.frame.width, height: height)
        self.insideScrollViewContainer.frame = CGRect(x: 0, y: 0, width: self.mainViewContainer.frame.width, height: height)
    }
}

//Collection View
extension dashboardRootVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("tapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
        
        cell.originalPhoto.image = imagesWithFaces.randomElement()
        cell.mainTag.text = mainTags[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
}

//Fetch photos
extension dashboardRootVC {
    
    func fetchPhotos() {
        
        let photosToFetch = 30
        
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = photosToFetch
        
        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = photosToFetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.images += [image]
                self.imagesToPost += [image]
            }
            
            // If you haven't already reached the first
            // index of the fetch result and if you haven't
            // already stored all of the images you need,
            // perform the fetch request again with an
            // incremented index
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                // Else you have completed creating your array
                print("Completed array: \(self.images)")
            }
        })
    }
}
