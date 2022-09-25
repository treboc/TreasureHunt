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
  var nextLocation: CLLocation? {
    didSet {
      reachedStation = false
    }
  }
  @Published var error: Error?
  @Published var angle: Double = 0
  @Published var heading: CLHeading? = nil
  @Published var distance: Double = 0
  @Published var wrongAuthorization: Bool = false
  @Published var reachedStation: Bool = false
  var triggerDistance: Double = 5
  private var cancellables = Set<AnyCancellable>()
  
  init(locationManager: CLLocationManager = CLLocationManager()) {
    self.locationManager = locationManager
    
    super.init()
    
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    
//    $location.sink(receiveValue: updateLocation).store(in: &cancellables)
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
      self.location = location
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

      if distance < triggerDistance {
        reachedStation = true
        stop()
      } else {
        reachedStation = false
        start()
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
