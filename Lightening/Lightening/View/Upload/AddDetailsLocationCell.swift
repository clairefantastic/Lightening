//
//  AddDetailsLocationCell.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import UIKit
import MapKit

class AddDetailsLocationCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        let location = CLLocation(latitude: 22.999696, longitude: 120.212768)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
