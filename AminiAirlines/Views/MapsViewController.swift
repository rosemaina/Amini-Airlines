//
//  MapsViewController.swift
//  AminiAirlines
//
//  Created by Rose Maina on 18/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import MapKit
import UIKit

class MapsViewController: UIViewController {

    @IBOutlet weak var mapsView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension MapsViewController: MKMapViewDelegate {
    
}
