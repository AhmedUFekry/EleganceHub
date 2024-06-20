//
//  ReviewViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 20/06/2024.
//

import Foundation
class ReviewViewModel{
    func getReviews() -> [Review]{
        return ReviewList.getReviewList()
    }
}
