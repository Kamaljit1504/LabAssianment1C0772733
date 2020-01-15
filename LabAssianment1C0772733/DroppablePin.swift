//
//  ViewController.swift
//  exercise2_iOS
//
//  Created by Ankita Jain on 2020-01-10.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import Foundation
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
