//
//  SettingsViewModel.swift
//  EleganceHub
//
//  Created by AYA on 05/06/2024.
//

import Foundation
import RxSwift
import RxRelay


class SettingsViewModel:CustomerDataProtocol{
    private let disposeBag = DisposeBag()
    
    private let dataBaseModel: DatabaseServiceProtocol = UserDefaultsHelper.shared
    var savedImage: UIImage?
    
    let customerResponse: PublishSubject<CustomerResponse> = PublishSubject<CustomerResponse>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error: PublishSubject<Error> = PublishSubject()
    
    
    func updateData(customerID:Int,firstName:String?,lastName:String?,email:String?,phone:String?){
        isLoading.accept(true)
        SettingsNetworkService.updateUserData(customerID: customerID, firstName: firstName, lastName: lastName, email: email, phone: phone)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] customerResponse in
                self?.customerResponse.onNext(customerResponse)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
    }
    
    func loadUSerData(customerID:Int){
        isLoading.accept(true)
        SettingsNetworkService.getUserInfo(customerID: customerID)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] customerResponse in
                self?.customerResponse.onNext(customerResponse)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error)
                self?.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }

    func saveImage(_ image: UIImage) {
        dataBaseModel.saveImage(image)
    }

    func loadImage() {
        savedImage = dataBaseModel.getImage()
    }
    func clearLoggedInImage() {
        dataBaseModel.clearImageProfile()
    }
    
    
}
