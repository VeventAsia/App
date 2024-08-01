//
//  CLLocationCoordinate2D+Equatable.swift
//  Vevent
//
//  Created by apple on 29/07/24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

