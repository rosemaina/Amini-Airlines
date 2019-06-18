//
//  Airports.swift
//  AminiAirlines
//
//  Created by Rose Maina on 18/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import Foundation
import MapKit

@objc class Airports: NSObject {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    static func getPlaces() -> [Airports] {
        guard let path = Bundle.main.path(forResource: "Airports", ofType: "plist"),
            let array = NSArray(contentsOfFile: path)
            else { return [] }
        
        var airports = [Airports]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let title = dictionary?["title"] as? String
            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
            
            let airport = Airports(title: title, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            airports.append(airport)
        }
        
        return airports as [Airports]
    }
}
