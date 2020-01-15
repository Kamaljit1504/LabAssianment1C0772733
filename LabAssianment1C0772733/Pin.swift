//
//  Pin.swift
//  Find My Way
//
//  Created by Ankita Jain on 2020-01-14.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import Foundation
import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
