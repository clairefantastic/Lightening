//
//  AddDetailsLocationCell.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import UIKit
import MapKit
import CoreLocation

class AddDetailsLocationCell: AddDetailsBasicCell, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    
    var locationHandler: ((Location) -> Void)?
    var location: Location?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        self.backgroundColor = UIColor.lightBlue
        
        mapView.delegate = self
        
        mapView.layer.cornerRadius = 10

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

}

extension AddDetailsLocationCell {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
        
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
            
        mapView.addAnnotation(mkAnnotation)
        
        locationHandler?(Location(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any] {
//                    if let Name = dict["Name"] as? String{
//                        if let City = dict["City"] as? String{
//                            self.currentLocationStr = Name + ", " + City
//                        }
//                    }
                }
            }
        }
        return currentLocationStr
    }

}
