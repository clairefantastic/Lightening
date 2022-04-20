//
//  AudioLocation.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import MapKit

class AudioAnnotation: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D
  let audioUrl: URL?

  init(
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D,
    audioUrl: URL?
  ) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate
    self.audioUrl = audioUrl
    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
