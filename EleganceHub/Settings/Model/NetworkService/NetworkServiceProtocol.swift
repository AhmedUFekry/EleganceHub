//
//  NetworkServiceProtocol.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation

protocol NetworkServiceProtocol{
    static func fetchCities(country: String,completionHandler: @escaping (Result<CitiesResponse, Error>) -> Void) 
}
