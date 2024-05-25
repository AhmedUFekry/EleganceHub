//
//  HomeViewModel.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation

class HomeViewModel {
    var vmResult : SmartCollections? {
        didSet {
            bindResultToViewController()
        }
    }
    var bindResultToViewController: (() -> ()) = {}

    func getBrandsFromModel() {
        NetworkCall.getBrands(complationhandler:{ result, error in 
            if let result = result {
                self.vmResult = result
            }else{
                print("ya lahwyyy ")
            }
        }
    )}
}
    

