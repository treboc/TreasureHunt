//  Created by Dominik Hauser on 14/03/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit
import CoreLocation
import Combine
import MapKit

enum LocationProviderError: Error {
  case noLocation
}

class LocationProvider: NSObject, ObservableObject {
  
  private let locationManager: CLLocationManager
  var location: CLLocation?
  var nextLocation: CLLocation?
  @Published var error: Error?
  @Published var angle: Double = 0
  @Published var heading: CLHeading? = nil
  @Published var distance: Double = 0
  @Published var wrongAuthorization: Bool = false
  @Published var reachedStation: Bool = false
  var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)
  private var cancellables = Set<AnyCancellable>()
  
//  var address: String? = nil {
//    didSet {
//      if let address = address {
//        CLGeocoder().geocodeAddressString(address) { placementMarks, error in
//          if let placementMark = placementMarks?.first, let location = placementMark.location {
//            self.nextLocation = location
//          } else {
//            self.error = error
//          }
//        }
//      }
//    }
//  }
  
  init(locationManager: CLLocationManager = CLLocationManager()) {
    
    self.locationManager = locationManager
    
    super.init()
    
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    
//    $nextLocation.sink(receiveValue: updateAddressLocation).store(in: &cancellables)
    $heading.sink(receiveValue: update).store(in: &cancellables)
  }
  
  func start() {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  func stop() {
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
  }
  
  func set(headingOrientation: CLDeviceOrientation) {
    locationManager.headingOrientation = headingOrientation
  }
  
  func reset() {
    nextLocation = nil
    distance = 0
  }
}

extension LocationProvider: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    switch manager.authorizationStatus {
      case .authorizedWhenInUse:
        wrongAuthorization = false
        print("authorizedWhenInUse")
        start()
      default:
        wrongAuthorization = true
        print("No authorization")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      updateLocation(location: location)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    heading = newHeading
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error \(error)")
  }
  
  private func updateLocation(location: CLLocation?) {
    updateAngle(heading: heading)
    updateDistance(location: location, nextLocation: nextLocation)
  }
  
  private func updateAddressLocation(addressLocation: CLLocation?) {
    updateAngle(heading: heading)
    updateDistance(location: location, nextLocation: addressLocation)
  }
  
  private func update(heading: CLHeading?) {
    updateAngle(heading: heading)
    updateDistance(location: location, nextLocation: nextLocation)
  }
  
  func updateAngle(heading: CLHeading?) {
    if let coordinate = nextLocation?.coordinate,
          let myCoordinate = location?.coordinate,
          let heading = heading {
      
      let bearing = myCoordinate.bearing(to: coordinate)
      angle = bearing - heading.magneticHeading
//    } else {
//      print("missing value \(addressLocation?.coordinate), \(location?.coordinate), \(heading)")
    }
  }
  
  func updateDistance(location: CLLocation?, nextLocation: CLLocation?) {
    if let location = location,
       let nextLocation = nextLocation {
      
      distance = location.distance(from: nextLocation)

      if distance < 5 {
        reachedStation = true
      } else {
        reachedStation = false
      }
    }
  }

  static func angle(coordinate: Coordinate, heading: CLLocationDirection?, deviceCoordinate: CLLocation?) -> Double {

    guard let deviceCoordinate = deviceCoordinate,
          let heading = heading else {
            return 0
          }
    let clCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let bearing = deviceCoordinate.coordinate.bearing(to: clCoordinate)
    return bearing - heading
  }
}
