//
//  ViewModel.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//

import UIKit
import SDWebImage
import RxSwift
import Reachability

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var InternetConnectionView: UIView!
    var isInternetConnection:Bool?
    weak var coordinator: AppCoordinator?
    
  
    var viewModel = HomeViewModel(network: NetworkManager.shared)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentCellIndex = 0
    var timer: Timer?
    var indecator: CustomIndicator?
    
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indecator = CustomIndicator(containerView: view.self)
        self.indecator?.start()
        
        isInternetConnection = Utils.isNetworkReachableTest()
        print(isInternetConnection!)
        if isInternetConnection == true {
            InternetConnectionView.isHidden = true
            viewModel.loadData(completion: { _ in
                self.indecator?.stop()
            })
        }else {
            InternetConnectionView.isHidden = false
            self.indecator?.stop()
        }
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
         
        guard let collectionView = collectionView else {
            fatalError("collectionView is nil")
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        startTimer()
        setupCollectionViewLayout()
        
        bindViewModel()
    }
    
   
    @IBAction func tryAgain(_ sender: Any) {
        
        indecator?.start()

        isInternetConnection = Utils.isNetworkReachableTest()
        if isInternetConnection == false {
            InternetConnectionView.isHidden = true
            viewModel.loadData(completion: { _ in
               // self.indecator?.stop()
                self.indecator?.start()
            })
        }else {
            InternetConnectionView.isHidden = false
            indecator?.stop()
        }
        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        coordinator?.goToFav()
    }
    
    private func bindViewModel() {
        viewModel.brandsObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            let count = viewModel.getBrandsCount()
            if count > 0 {
                self.indecator?.start()
            } else {
                self.indecator?.start()
            }
            return viewModel.getBrandsCount()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
            cell.img.image = UIImage(named: "\(indexPath.row)")
            return cell
        } else {
            self.indecator?.stop()
            let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandcell", for: indexPath) as! BrandCollectionViewCell
            if let imageUrl = URL(string: viewModel.getBrands()[indexPath.row].image?.src ?? "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402") {
                brandCell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
            }
            return brandCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if indexPath.section == 0 {
              // Handle navigation for the first section if needed
          } else {
             
              let selectedBrand = viewModel.getBrands()[indexPath.row]
              coordinator?.goToProducts(brandID: selectedBrand.id ?? 0)
          }
      }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderViewCollectionReusableView
            switch indexPath.section {
            case 0:
                headerView.header.text = ""
            case 1:
                headerView.header.text = "Brands"
            default:
                headerView.header.text = ""
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNext), userInfo: nil, repeats: true)
    }

    @objc func moveToNext() {
        currentCellIndex = (currentCellIndex + 1) % 8
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func createDiscountSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32)
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(10))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    func createBrandSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing:10)
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalWidth(0.5))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [horizontalGroup])
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 2, trailing: 4)
        section.interGroupSpacing = 10
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    func setupCollectionViewLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createDiscountSectionLayout()
            case 1:
                return self.createBrandSectionLayout()
            default:
                return nil
            }
        }
        collectionView.collectionViewLayout = layout
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        bindSearchBar()
    }
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.filterBrands(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterBrands(query: searchText)
    }
}
