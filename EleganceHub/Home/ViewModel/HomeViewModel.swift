//
//  HomeViewModel.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModelProtocol {
    let draftOrderID = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    private let cartNetworkService:CartNetworkServiceProtocol = CartNetworkService()
   
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
                    dispatchGroup.enter()
                    NetworkCall.getDiscountCodes(discountId: priceRule.id!) { result in
                        switch result{
                            case .success(let couponsResponse):
                            //print("getDiscountCodes \(couponsResponse)")
                            if let firstDiscountCode = couponsResponse.discount_codes.first {
                                couponsList.append(firstDiscountCode)
                            }
                            case .failure(let err):
                                print("Error home \(err)")
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        //print("All discount codes fetched: \(couponsList)")
                        self.couponsResult = couponsList
                    }
                }
            case .failure(let failure):
                print(failure)
                self.failureIngetData(failure.localizedDescription)
            }
        }
    }
    
    func checkIfUserHasDraftOrder(customerID: Int) {
       cartNetworkService.getAllDraftOrders()
           .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
           .observe(on: MainScheduler.instance)
           .subscribe(onNext: { [weak self] draftResponses in
               guard let self = self else { return }
               let draftOrders = draftResponses.draftOrders ?? []
               let draftList = draftOrders.filter { $0.customer?.id == customerID }
               //print("draftList.first?.id \(draftResponses)")
               if let id = draftList.first?.id {
                   print("Draft Order ID for user \(customerID) is \(id)")
                   self.draftOrderID.onNext(id)
               } else {
                   print("No draft orders found for user \(customerID)")
                   self.draftOrderID.onNext(0)
               }
               self.draftOrderID.onCompleted()
           }, onError: { [weak self] error in
               print("Error fetching draft orders: \(error)")
               self?.draftOrderID.onNext(0)
               self?.draftOrderID.onCompleted()
           }).disposed(by: disposeBag)
    }

}
    

