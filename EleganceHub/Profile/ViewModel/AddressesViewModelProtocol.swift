//
//  ViewModelProtocol.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation

protocol AddressesViewModelProtocol{
    var listOfCountries:[CountryDataModel]? {get set}
    var bindCountriesList:((_ countries:[CountryDataModel]) -> ()) {get set}
    
    var listOfCities:[String]? {get set}
    var bindCitiesList:((_ cities:[String]) -> ()) {get set}
    
    
    func configrationCountries()
    func getCitiesOfSelectedCountry(selectedCountry:String)
    
    func addNewAddress(customerID: Int, addressData: AddressData)
    
    var failureResponse:((_ error:String) -> ()) {get set}
}
