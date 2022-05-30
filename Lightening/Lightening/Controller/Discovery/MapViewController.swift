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
        
        self.navigationItem.title = VolunteerTab.map.tabBarItem().title
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        view.stickSubView(mapView)
        mapView.layer.cornerRadius = 10
        mapView.delegate = self
        
        determineCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(self.audioAnnotations)
        
        notifyBlockUser()
    }
    
    func notifyBlockUser() {
        
        PublishManager.shared.fetchAudios { [weak self] result in
            
            switch result {
            
            case .success(let audios):
                
                self?.audios = []
                
                if let blockList = UserManager.shared.currentUser?.blockList {
                    
                    for audio in audios where blockList.contains(audio.authorId ) == false {
                        
                        self?.audios.append(audio)
                    }
                } else {
                    
                    self?.audios = audios
                }
                
                self?.audioAnnotations = []
                
                self?.audios.forEach { audio in
                    
                    self?.audioAnnotations.append(AudioAnnotation(title: audio.title, locationName: audio.author?.displayName,
                        coordinate: CLLocationCoordinate2DMake(audio.location?.latitude ?? 0.0, audio.location?.longitude ?? 0.0), audioUrl: audio.audioUrl))
                }
                
                self?.mapView.addAnnotations(self?.audioAnnotations ?? [])
                
                LKProgressHUD.dismiss()
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
                
                LKProgressHUD.showFailure(text: "Fail to fetch Map Page data")
            }
            
        }
    }
    
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
          
        guard let annotation = annotation as? AudioAnnotation else {
          return nil
        }
          
        let identifier = "audio"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {

          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
            
          let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.setImage(UIImage.asset(ImageAsset.blackVinyl), for: .normal)
          view.rightCalloutAccessoryView = button
        
        }
        return view
      }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as? AudioAnnotation
        let audioFile = audios.filter { $0.audioUrl == annotation?.audioUrl }
        
        showPlayer(audio: audioFile[0])
    }
    
}
