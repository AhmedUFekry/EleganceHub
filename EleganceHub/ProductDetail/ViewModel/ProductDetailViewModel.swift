//
//  ProductDetailViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//

import Foundation
import UIKit
import RxSwift

protocol ProductDetailViewModelProtocol {
    var draftOrder: PublishSubject<DraftOrder> { get set }
    var error: PublishSubject<Error> { get set }
    
    func getProductDetails(productId: Int)
    func getAvailableVarients(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void)
    func createNewDraftOrderAndPostNewItem(customerID:Int,product: Product)
    
    func updateCustomerDraftOrder(orderID:Int,customerID:Int,newProduct:Product)
    
}

class ProductDetailViewModel: ProductDetailViewModelProtocol {
    private let networkService:CartNetworkServiceProtocol = CartNetworkService()
    private let disposeBag = DisposeBag()
    var draftOrder: PublishSubject<DraftOrder> = PublishSubject<DraftOrder>()
    var error: PublishSubject<Error> = PublishSubject<Error>()
 
    var bindingProduct: (() -> Void)?
    var productVariants: [Variant] = []
    
    var observableProduct: Product? {
        didSet {
            bindingProduct?()
        }
    }
    
    var networkManager: DetailNetworkProtocol
    
    init(networkManager: DetailNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func getProductDetails(productId: Int) {
        networkManager.getProductDetails(productId: productId) { [weak self] fetchProduct in
            guard let self = self else { return }
            self.observableProduct = fetchProduct?.product
            
            if let product = fetchProduct?.product {
                self.productVariants = product.variants ?? []
            } else {
                print("Failed to fetch product details")
            }
        }
    }
    
    func getAvailableVarients(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void) {
        networkManager.getProductDetails(productId: productId) { fetchProduct in
            guard let variants = fetchProduct?.product?.variants else {
                print("Failed to fetch product variants")
                completion([:], [])
                return
            }
            
            var sizeColorMap: [String: [String]] = [:]
            var colors: [String] = []
            
            for variant in variants {
                if let title = variant.title {
                    let components = title.components(separatedBy: "/")
                    if components.count == 2 {
                        let size = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
                        let color = components.last?.trimmingCharacters(in: .whitespaces) ?? ""
                        sizeColorMap[size, default: []].append(color)
                        if !colors.contains(color) {
                            colors.append(color)
                        }
                    }
                }
            }
            
            print("Size-Color Map: \(sizeColorMap)")
            print("Available Colors: \(colors)")
            
            completion(sizeColorMap, colors)
        }
    }
    
    func createNewDraftOrderAndPostNewItem(customerID: Int, product: Product) {
        networkService.postItemToCartNewProduct(customerID: customerID, product: product)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponse in
                //print("product VM \(draftResponse)")
                guard let order = draftResponse.draftOrders else {
                    self?.error.onNext(MyError.noDraftOrders)
                    return
                }
                self?.draftOrder.onNext(order)
                self?.draftOrder.onCompleted()
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            }).disposed(by: disposeBag)
    }
    
    func updateCustomerDraftOrder(orderID:Int,customerID:Int,newProduct:Product) {
        networkService.getCustomerOrder(orderID: orderID) { orderResponse in
            switch orderResponse{
                case .success(let data):
                    print("getCustomerOrder data response draft order View model response \(data)")
                    DispatchQueue.global(qos: .default).async {
                        let properties: [Property] = [
                            Property(name: "Image", value: newProduct.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"),
                            Property(name: "Quantity", value: "\(newProduct.variants?.first?.inventory_quantity ?? 1)")
                        ]
                        let newLineItem = LineItem(id: nil, variantID: newProduct.variants?.first?.id ?? -1, productID: newProduct.id ?? -1, title: newProduct.title, variantTitle: newProduct.variants?.first?.title, productImage: nil, vendor: nil, quantity: 1, requiresShipping: nil, taxable: nil, giftCard: nil, fulfillmentService: nil, grams: nil, appliedDiscount: nil, name: nil, custom: nil, price: nil, adminGraphqlAPIID: nil,properties: properties)
                        print("Data new Line Item Before append data.lineItems?.count \(data.lineItems?.count)")
                        //data.lineItems?.append(newLineItem)
                        var newOrder = PostDraftOrderResponse(draftOrders: data)
                        print("Data new Line Item Before append newOrder.draftOrders?.lineItems?.count \(newOrder.draftOrders?.lineItems?.count)")
//                        var newList = data.lineItems ?? []
//                        newList.append(newLineItem)
                        newOrder.draftOrders?.lineItems?.append(newLineItem)
                        print("Data new Line Item after append newOrder.draftOrders?.lineItems?.count \(newOrder.draftOrders?.lineItems?.count)")
                        self.addNewItemToOrder(orderID: orderID,updatedList: newOrder.draftOrders!)
                    }
                case .failure(let err):
                    print("Error \(err)")
            }
        }
    }
    
    private func addNewItemToOrder(orderID:Int,updatedList:DraftOrder){
        networkService.addNewLineItemToDraftOrder(orderID: orderID,updatedDraftOrder: updatedList)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] draftResponse in
                guard let order = draftResponse.draftOrders else {
                    self?.error.onNext(MyError.noDraftOrders)
                    return
                }
                //print("Updated draft order \(draftResponse)")
                self?.draftOrder.onNext(order)
                self?.draftOrder.onCompleted()
            }, onError: { [weak self] error in
                self?.error.onNext(error)
            }).disposed(by: disposeBag)
    }
    
}

    
enum MyError: Error {
    case noDraftOrders
    case networkError(String)
    case errorAtCopuns
}

extension ProductDetailViewModelProtocol: ConnectivityProtocol, NetworkStatusProtocol{
    
    func networkStatusDidChange(connected: Bool) {
        isConnected = connected
        print("networkStatusDidChange called \(isConnected)")
        checkForConnection()
    }
    
    private func checkForConnection(){
        guard let isConnected = isConnected else {
            ConnectivityUtils.showConnectivityAlert(from: self)
            print("is connect nilllllll")
            return
        }
        if isConnected{
            getData()
        }else{
           // ConnectivityUtils.showConnectivityAlert(from: self)
        }
    }
    
    private func getData(){
        checkForUser()
    }
 
}
