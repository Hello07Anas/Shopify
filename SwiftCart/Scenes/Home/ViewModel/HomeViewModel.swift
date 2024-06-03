//
//  ViewModel.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//


import Foundation
import UIKit
import Network
import RxSwift

class HomeViewModel{
    var brandsArray = [Brand]()
  
    
private let disposeBag = DisposeBag()
    
    let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/smart_collections.json"
    
    init() {
        NetworkManager.shared.getApiData(url: url)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] (brandResponse: BrandResponse) in
                        print("ViewModel: Received brand response")
                        guard let self = self else { return }
                        self.brandsArray = brandResponse.brands
                        print("ViewModel: Number of brands: \(self.brandsArray.count)")
                    }, onError: { error in
                        print("ViewModel: API Error: \(error.localizedDescription)")
                    })
                    .disposed(by: disposeBag)
            }
        }
