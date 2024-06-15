//
//  PaymentViewModel.swift
//  EleganceHub
//
//  Created by AYA on 14/06/2024.
//

import Foundation
import RxSwift
import RxRelay

class PaymentViewModel{
    let networkService:PaymentServiceProtocol!
    let draftOrderNetworkService:CartNetworkServiceProtocol = CartNetworkService()
    let disposeBag = DisposeBag()
    let isCompleted:PublishSubject<Bool> = PublishSubject<Bool>()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    
    init(networkService: PaymentServiceProtocol!) {
        self.networkService = networkService
    }
    
    func completeDraftOrder(orderID: Int) {
        isLoading.accept(true)
        networkService?.completeDraftOrder(orderID: orderID) { success, error in
            if success {
                self.deleteOrderAfterComplete(orderID: orderID)
            }else{
                self.isCompleted.onNext(false)
                self.isLoading.accept(false)
            }
       }
   }
    
    private func deleteOrderAfterComplete(orderID: Int){
        draftOrderNetworkService.deleteDraftOrder(orderID: orderID)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDeleted in
                print("is delete \(isDeleted)")
                self?.isCompleted.onNext(isDeleted)
            }, onError: { [weak self] error in
                self?.isCompleted.onNext(false)
            },onCompleted: {
                print("On Complete")
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)

    }
}
