//
//  HomeViewModel.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation

class HomeViewModel: ViewModelProtocol {
   
    var couponsResult: [DiscountCodes]?{
        didSet{
            bindCouponsToViewController()
            print("couponsResult did called \(couponsResult?.count)")
        }
    }
    
    var vmResult : SmartCollections? {
        didSet {
            bindResultToViewController()
        }
    }
    
    var bindResultToViewController: (() -> ()) = {}
    var bindCouponsToViewController: (() -> ()) = {}
    
    var failureIngetData:((_ err: String) -> ()) = {err in }

    func getBrandsFromModel() {
        NetworkCall.getBrands(complationhandler:{ result, error in 
            if let result = result {
                self.vmResult = result
            }else{
                print("ya lahwyyy ")
                self.failureIngetData(error?.localizedDescription ?? "Failed")
            }
        }
    )
        
    }
    
    func getCouponsFromModel() {
        NetworkCall.getPriceRules { [self] response in
            switch response {
            case .success(let success):
                
                print("price rule Id \(success.price_rules[0].id)")
                var couponsList: [DiscountCodes] = []
                let dispatchGroup = DispatchGroup()
                
                for priceRule in success.price_rules{
                    dispatchGroup.enter() // Enter the DispatchGroup for each async operation
                    
                    NetworkCall.getDiscountCodes(discountId: "\(priceRule.id!)") { result in
                        switch result{
                            case .success(let couponsResponse):
                            print("getDiscountCodes \(couponsResponse)")
                            if let firstDiscountCode = couponsResponse.discount_codes.first {
                                couponsList.append(firstDiscountCode)
                            }
                            case .failure(let err):
                                print("Error home \(err)")
                        }
                        dispatchGroup.leave() // Leave the DispatchGroup when the async operation completes
                    
                    }
                    dispatchGroup.notify(queue: .main) {
                        // This block is called when all async operations complete
                        print("All discount codes fetched: \(couponsList)")
                        self.couponsResult = couponsList
                    }
                }
            case .failure(let failure):
                print(failure)
                self.failureIngetData(failure.localizedDescription)
            }
        }
    }
}
    

