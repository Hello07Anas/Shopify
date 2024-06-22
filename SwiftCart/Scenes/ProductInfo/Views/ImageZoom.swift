//
//  ImageZoom.swift
//  SwiftCart
//
//  Created by Anas Salah on 22/06/2024.
//

import UIKit

class ImageZoom: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageURLs: [URL]
    var selectedImageURL: URL?
    var coordinator: AppCoordinator?

    init(imageURLs: [URL], selectedImageURL: URL?) {
        self.imageURLs = imageURLs
        self.selectedImageURL = selectedImageURL
        super.init(nibName: "ImageZoom", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        print("coordinator?.finish()")
        coordinator?.finish()
        print(coordinator as Any)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupPageControl()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cellNib = UINib(nibName: "productImgCellCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "productImgCellCollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.frame.size
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        
        if let selectedImageURL = selectedImageURL, let index = imageURLs.firstIndex(of: selectedImageURL) {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            pageController.currentPage = index
        }
    }
    
    func setupPageControl() {
        pageController.numberOfPages = imageURLs.count
        pageController.currentPage = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImgCellCollectionViewCell", for: indexPath) as! productImgCellCollectionViewCell
        
        let imageURL = imageURLs[indexPath.item]
        cell.configure(with: imageURL)
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
