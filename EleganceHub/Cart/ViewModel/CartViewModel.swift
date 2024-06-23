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
    
    var lineItemsList: PublishSubject<[LineItem]> = PublishSubject<[LineItem]>()
    var draftOrder: PublishSubject<DraftOrder> = PublishSubject<DraftOrder>()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isValiedCopoun: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var error: PublishSubject<Error> = PublishSubject<Error>()
    
    var networkService:CartNetworkServiceProtocol = CartNetworkService()
    var showAlertQuantity:Bool? {
        didSet{
            showAlert()
        }
    }
    var showAlert:()->Void = { }
    
    private let disposeBag = DisposeBag()
    private var items = [LineItem]()
    
    func getDraftOrderForUser(orderID: Int) {
        isLoading.accept(true)
        networkService.getDraftOrderForUser(orderID: orderID)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] draftOrdersResponse in
                self?.isLoading.accept(false)
                self?.items = draftOrdersResponse.draftOrders?.lineItems ?? []
                if let draftOrder = draftOrdersResponse.draftOrders {
                    self?.draftOrder.onNext(draftOrder)
                }else{
                    self?.error.onNext(MyError.noDraftOrders)
                }
                self?.lineItemsList.onNext(draftOrdersResponse.draftOrders?.lineItems ?? [])
                //self?.lineItemsList.onCompleted()
            } onError: {[weak self] error in
                self?.error.onNext(error)
                self?.isLoading.accept(false)
            }.disposed(by: disposeBag)
    }
    
    func deleteDraftOrder(orderID: Int) {
        //self.isLoading.accept(true)
        networkService.deleteDraftOrder(orderID: orderID)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDeleted in
                print("is delete \(isDeleted)")
                self?.lineItemsList.onNext([])
                //self?.lineItemsList.onCompleted()
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            },onCompleted: {
                print("On Complete")
            })
            .disposed(by: disposeBag)
    }
    
    func deleteItemFromDraftOrder(orderID:Int, itemID:Int){
        networkService.getCustomerOrder(orderID: orderID) { orderResponse in
            switch orderResponse{
            case .success(let data):
                print("getCustomerOrder data response draft order View model response \(data)")
                var newOrder = PostDraftOrderResponse(draftOrders: data)
                print("Data new Line Item Before Delete \(newOrder.draftOrders?.lineItems?.count)")
                newOrder.draftOrders?.lineItems?.removeAll(where: { $0.id == itemID })
                print("Data new Line Item after Delete Order  \(newOrder.draftOrders?.lineItems?.count)")
                self.updatedItemToOrder(orderID: orderID,updatedList: newOrder.draftOrders!)
            case .failure(let err):
                print("Error \(err)")
            }
        }
    }
    
    private func updatedItemToOrder(orderID:Int,updatedList:DraftOrder){
        networkService.addNewLineItemToDraftOrder(orderID: orderID,updatedDraftOrder: updatedList)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponse in
                guard let order = draftResponse.draftOrders else {
                    self?.error.onNext(MyError.noDraftOrders)
                    return
                }
                print("Updated draft order \(draftResponse)")
                self?.items = order.lineItems ?? []
                self?.lineItemsList.onNext(order.lineItems ?? [])
                ///self?.lineItemsList.onCompleted()
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            }).disposed(by: disposeBag)
    }
    
    func incrementQuantity(at index: Int) {
        guard index < items.count else { return }
        guard let q = items[index].quantity else{return}
        if q < Int(items[index].properties![1].value!) ?? 1{
            items[index].quantity = q + 1
            print("incrementQuantity at index \(index) is \(items[index].quantity )")
            print("incrementQuantity q = \(q) and after added is \( items[index].quantity) the all quantity is \(items[index].properties![1].value!)")
            lineItemsList.onNext(items)
        }else{
            
            showAlertQuantity = true
        }
    }
    
    func decremantQuantity(at index: Int){
        guard index < items.count else { return }
        guard let q = items[index].quantity else{return}
        if q > 1{
            items[index].quantity = q - 1
            print("decremantQuantity at index \(index) is \(items[index].quantity )")
            print("decremantQuantity q = \(q) and after added is \( items[index].quantity) the all quantity is \(items[index].properties![1].value!)")
            lineItemsList.onNext(items)
        }else{
            showAlertQuantity = false
        }
       
    }
    
    func updateLatestListItem(orderID:Int) {
        networkService.getCustomerOrder(orderID: orderID) { orderResponse in
            switch orderResponse{
            case .success(let data):
                print("getCustomerOrder data response draft order View model response \(data)")
                var newOrder = PostDraftOrderResponse(draftOrders: data)
                print("Data new Line Item Before Delete \(newOrder.draftOrders?.lineItems?.count)")
                newOrder.draftOrders?.lineItems = self.items
                print("Data new Line Item after Delete Order  \(newOrder.draftOrders?.lineItems?.count)")
                //self.updatedItemToOrder(orderID: orderID,updatedList: newOrder.draftOrders!)
                self.networkService.addNewLineItemToDraftOrder(orderID: orderID,updatedDraftOrder: newOrder.draftOrders!)
                    .subscribe(on:ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onCompleted: {
                        print("Complete")
                    }).disposed(by: self.disposeBag)
                
            case .failure(let err):
                print("Error \(err)")
            }
        }
    }
    
    func checkForCopuns(copunsString: String, draftOrder:DraftOrder) {
        networkService.checkForCopuns(discountCode: copunsString) { result in
            switch result{
                case .success(let response):
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let id = response.price_rule_id {
                            self.networkService.getPriceRule(priceRuleID: id){ response in
                                switch response{
                                case .success(let data):
                                    //print("Price Rule response is \(data.title)")
                                    
                                    var value = 1.0
                                    if let stringValue = data.value, let doubleValue = Double(stringValue) {
                                        print("Double value: \(doubleValue * -1)")
                                        value = doubleValue * -1.0
                                    } else {
                                        print("Failed to convert optional string to Double")
                                    }
                                   let discount = AppliedDiscount(description: nil, value: "\(value)" , title: data.title, amount: nil, valueType: data.value_type)
                                    //print("Discount \(discount)")
                                    var newDraftOrder = draftOrder
                                    newDraftOrder.appliedDiscount = discount
                                        //print("Discount new dtaft order \(newDraftOrder)")
                                        //print("Discount dtaft order \(draftOrder)")
                                    self.updateDraftOrder(orderID: newDraftOrder.id!, draftOrder: newDraftOrder)
                                case .failure(let error):
                                    print("Error in priceRule \(error)")
                                    self.error.onNext(MyError.errorAtCopuns)
                                }
                            }
                        }
                    }
                case .failure(let err):
                    print("responseeeeee error \(err)")
                self.error.onNext(MyError.errorAtCopuns)
            }
        }
    }
    
    func updateDraftOrder(orderID:Int, draftOrder:DraftOrder){
        networkService.updateDraftOrder(orderID: orderID, draftOrder: draftOrder)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponse in
                guard let order = draftResponse.draftOrders else {
                    self?.error.onNext(MyError.noDraftOrders)
                    return
                }
                print("Updated draft order \(draftResponse.draftOrders)")
                self?.isValiedCopoun.accept(true)
                self?.draftOrder.onNext(order)
                self?.lineItemsList.onNext(order.lineItems ?? [])
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            }).disposed(by: disposeBag)
    }
    
}
