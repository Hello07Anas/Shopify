//
//  OnBoardingScreenViewController.swift
//  SwiftCart
//
//  Created by Elham on 21/06/2024.
//

import UIKit

class OnBoardingScreenViewController: UIViewController, OnBoardingScreenCell {
    var currentCellIndex = 0
    var timer: Timer?
   
    @IBOutlet weak var pageControl: UIPageControl!
    private let sliders: [Slide] = Slide.collection

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        startTimer()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
     //  collectionView.contentInsetAdjustmentBehavior = .never
     //  collectionView.isPagingEnabled = true
    }

    func setupPageControl() {
        pageControl.numberOfPages = sliders.count
        pageControl.currentPage = 0
    }

    func getStarted() {
        self.coordinator?.getStarted()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNext), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func moveToNext() {
        if currentCellIndex < sliders.count - 1 {
            currentCellIndex += 1
        } 
        
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
        updatePageControlVisibility()
    }

    func updatePageControlVisibility() {
        if sliders[currentCellIndex].buttonTitle == "Get Started" {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
    }
}

extension OnBoardingScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardingCell", for: indexPath) as! OnBoardingCollectionViewCell
        cell.delegate = self
        cell.configer(with: sliders[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / collectionView.frame.width)
        currentCellIndex = pageIndex
        pageControl.currentPage = currentCellIndex
        updatePageControlVisibility()
    }
}

protocol OnBoardingScreenCell: AnyObject {
    func getStarted()
}

class OnBoardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discrebtion: UILabel!
    weak var delegate: OnBoardingScreenCell?
    
    func configer(with slide: Slide) {
        titleLabel.text = slide.title
        discrebtion.text = slide.dec
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        actionButton.tintColor = slide.buttonColor
        
        if slide.buttonTitle == "Next" {
            actionButton.isHidden = true
        } else {
            actionButton.isHidden = false
        }
        
        let animationName = slide.animationName
        animationView.image = UIImage(named: animationName)
    }
    
    @IBAction func actionButtontapped(_ sender: Any) {
        if actionButton.title(for: .normal) == "Get Started" {
            delegate?.getStarted()
        }
    }
}

struct Slide {
    let title: String
    let dec: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static var collection: [Slide] = [
        Slide(title: "Your Own Style", dec: "Explore our smart, cool, and fashionable collections to make you stand out.", animationName: "onBoarding1", buttonColor: .systemRed, buttonTitle: "Next"),
        Slide(title: "Seamless Shopping Experience", dec: "Navigate through categories and brands effortlessly. Enjoy a seamless, intuitive shopping journey designed just for you.", animationName: "onBoarding2", buttonColor: .systemGreen, buttonTitle: "Next"),
        Slide(title: "Choose the Preferred Product", dec: "When you purchase items, we will provide you with exclusive coupons, special offers, and rewards.", animationName: "onBoarding3", buttonColor: .systemPink, buttonTitle: "Next"),
        Slide(title: "Get Your Order", dec: "Find your perfect products easily. Enter your address and let us do the rest.", animationName: "onBoarding4", buttonColor: .black, buttonTitle: "Get Started")
    ]
}
