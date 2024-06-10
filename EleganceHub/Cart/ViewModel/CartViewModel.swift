//
//  CartViewModel.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import RxSwift
import RxRelay

class CartViewModel:CartViewModelProtocol{
    var productItem: PublishSubject<PostDraftOrderResponse> = PublishSubject<PostDraftOrderResponse>()
    var draftOrdersList: PublishSubject<[DraftOrder]> = PublishSubject<[DraftOrder]>()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var error: PublishSubject<Error> = PublishSubject<Error>()
    
    var networkService:CartNetworkServiceProtocol = CartNetworkService()
    private let disposeBag = DisposeBag()
    
    func addToCart(customerID: Int, product: Product,selectedSize:String) {
        isLoading.accept(true)
        networkService.addToCartNewProduct(customerID: customerID, product: product,selectedSize: selectedSize)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponse in
                self?.productItem.onNext(draftResponse)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
    }
    
    func getAllDraftOrdersForUser(customerID: Int) {
        isLoading.accept(true)
        networkService.getAllDraftOrders()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponses in
                    var draftList:[DraftOrder] = []
                    print("draft Order List All  \(draftResponses.draftOrders?.count)")
                    guard let listResponse = draftResponses.draftOrders else{
                        self?.draftOrdersList.onNext(draftList)
                        self?.isLoading.accept(false)
                        return
                    }
                    draftList = listResponse.filter { order in
                        order.customer?.id == customerID
                    }
                    print("draft Order List for user  \(draftList.count)")
                self?.draftOrdersList.onNext(draftList)
                    self?.isLoading.accept(false)
                },onError: { [weak self] error in
                    self?.error.onNext(error)
                    self?.isLoading.accept(false)
                }).disposed(by: disposeBag)
    }
    
    func deleteDraftOrder(orderID: Int,customerID:Int) {
        networkService.deleteDraftOrder(orderID: orderID)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                //self?.getAllAddresses(customerID: customerID)
                self?.getAllDraftOrdersForUser(customerID: customerID)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
