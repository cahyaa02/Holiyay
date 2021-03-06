//
//  Destination.swift
//  Holiyay
//
//  Created by MacBook Pro on 04/05/22.
//

import Foundation
import SwiftUI
import CoreLocation

struct Destination: Hashable, Codable, Identifiable {
    var id: Int = 0
    var name: String = ""
    var country: String = ""
    var description: String = ""
    var city: String = ""
    var isBookmark: Bool = false
    var visitDate: String?
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case beaches = "Beaches"
        case deserts = "Deserts"
        case forests = "Forests"
        case mountains = "Mountains"
    }
    
    private var imageExploreBookmark: String
    var thumbnail: Image {
        Image(imageExploreBookmark)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
