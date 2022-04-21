//
//  MapViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private let mapView = MKMapView()
    
    private let locationManager = CLLocationManager()
    
    private var audioAnnotations: [AudioAnnotation] = []
    
    private var audioFiles: [Audio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutMapView()
        
        mapView.delegate = self
        
        determineCurrentLocation()
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation: CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(mRegion, animated: true)
        
        PublishManager.shared.fetchAudioFiles() { [weak self] result in
            
            switch result {
            
            case .success(let audioFiles):
                
                self?.audioFiles = audioFiles
                
                audioFiles.forEach { audioFile in
                    
                    self?.audioAnnotations.append(AudioAnnotation(title: audioFile.title, locationName: "Claire",
                        coordinate: CLLocationCoordinate2DMake(audioFile.location?.latitude ?? 0.0, audioFile.location?.longitude ?? 0.0), audioUrl: audioFile.audioUrl))
                    
                }
                
                self?.mapView.addAnnotations(self?.audioAnnotations ?? [])
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
      ) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? AudioAnnotation else {
          return nil
        }
        // 3
        let identifier = "audio"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          // 5
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        }
        return view
      }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as? AudioAnnotation
        let audioFile = audioFiles.filter { $0.audioUrl == annotation?.audioUrl }
        let playerView = AudioPlayerView()
        playerView.audio = audioFile[0]
        playerView.frame = CGRect(x: 0, y: height - 80, width: width, height: 80)
        playerView.backgroundColor?.withAlphaComponent(0)
        mapView.addSubview(playerView)
        UIView.animate(withDuration: 0.25, delay: 0.0001, options: .curveEaseInOut, animations: { playerView.frame = CGRect(x: 0, y: height - 80, width: width, height: 80)}, completion: {_ in })
        
    }
    
}

extension MapViewController {
    
    func layoutMapView() {
        
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
}
