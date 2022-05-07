//
//  MapViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController {
    
    private let mapView = MKMapView()
    
    private let locationManager = CLLocationManager()
    
    private var audioAnnotations: [AudioAnnotation] = []
    
    private var audios: [Audio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutMapView()
        
        mapView.delegate = self
        
        determineCurrentLocation()
        
        self.navigationItem.title = "Map"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
    
    func determineCurrentLocation() {
        locationManager.delegate = self
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
        
        locationManager.stopUpdatingLocation()
        
        PublishManager.shared.fetchAudios() { [weak self] result in
            
            switch result {
            
            case .success(let audios):
                
                if let blockList = UserManager.shared.currentUser?.blockList {
                    
                    for audio in audios where blockList.contains(audio.authorId ?? "") == false {
                        
                        self?.audios.append(audio)
                        
                    }
                } else {
                    
                    self?.audios = audios
                }
                
                self?.audios.forEach { audio in
                    
                    self?.audioAnnotations.append(AudioAnnotation(title: audio.title, locationName: audio.author?.displayName ?? "Lighty",
                        coordinate: CLLocationCoordinate2DMake(audio.location?.latitude ?? 0.0, audio.location?.longitude ?? 0.0), audioUrl: audio.audioUrl))
                    
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
            
          let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.setImage(UIImage(named: "black_vinyl-PhotoRoom"), for: .normal)
          view.rightCalloutAccessoryView = button
        
        }
        return view
      }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as? AudioAnnotation
        let audioFile = audios.filter { $0.audioUrl == annotation?.audioUrl }
        
        let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height ?? 50
        let audioPlayerViewController = AudioPlayerViewController()
        self.addChild(audioPlayerViewController)
        audioPlayerViewController.audio = audioFile[0]
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        self.view.addSubview(audioPlayerViewController.view)
        audioPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .centerX, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
        
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
