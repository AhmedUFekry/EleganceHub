//
//  ReviewList.swift
//  EleganceHub
//
//  Created by Shimaa on 18/06/2024.
//

import Foundation

protocol ReviewListProtocol{
    static func getReviewList()-> [Review]
}

class ReviewList :ReviewListProtocol{
    
    static let myReviews: [Review] = [
        Review(image: "Shimaa Mohamed", text: "very nice and perfect size", rate: 5.00, date: getRandomDate()),
        Review(image: "Aya Ahmed", text: "good trail", rate: 4.00, date: getRandomDate()),
        Review(image: "Ahmed Khaled", text: "bad quality", rate: 2.00, date: getRandomDate()),
        Review(image: "Raneem Ahmed", text: "very nice", rate: 4.50, date: getRandomDate()),
        Review(image: "Mayar Mostafa", text: "great", rate: 3.50, date: getRandomDate()),
        Review(image: "Ali Abdalla", text: "not the same color", rate: 3.00, date: getRandomDate()),
        Review(image: "Sara Hany", text: "excellent product", rate: 4.80, date: getRandomDate()),
        Review(image: "Mohamed Hassan", text: "fast delivery", rate: 4.20, date: getRandomDate()),
        Review(image: "Nour Hamdy", text: "beautiful design", rate: 4.70, date: getRandomDate()),
        Review(image: "Youssef Ibrahem", text: "average experience", rate: 3.25, date: getRandomDate()),
        Review(image: "Lina Othman", text: "amazing product", rate: 4.90, date: getRandomDate()),
        Review(image: "Mai Essam", text: "I really love it and reccommend it", rate: 4.0, date: getRandomDate()),
        Review(image: "Aya Sami", text: "fast delivery", rate: 4.20, date: getRandomDate()),
        Review(image: "Zad Hussen", text: "beautiful design", rate: 4.70, date: getRandomDate()),
        Review(image: "Serag Ali", text: "different color and size", rate: 3.25, date: getRandomDate()),
    ]
    
    static func getReviewList() -> [Review] {
        return myReviews
    }
    
    static func getRandomDate() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let twoYearsAgo = calendar.date(byAdding: .year, value: -2, to: currentDate)!
        
        let randomTimeInterval = TimeInterval.random(in: twoYearsAgo.timeIntervalSince1970...currentDate.timeIntervalSince1970)
        let randomDate = Date(timeIntervalSince1970: randomTimeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: randomDate)
    }
}
