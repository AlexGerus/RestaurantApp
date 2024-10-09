//
//  Review.swift
//  RestaurantApp
//
//  Created by Alexander Gerus on 30.08.2023.
//

import Foundation

struct Review: Codable {
    var id: UUID?
    var title: String
    var body: String
    var restaurant: Restaurant?
}
