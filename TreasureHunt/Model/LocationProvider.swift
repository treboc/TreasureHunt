//  Created by Dominik Hauser on 14/03/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Combine
import MapKit
import UIKit

enum LocationProviderError: Error {
  case wrongAuthorization(CLAuthorizationStatus)
  case noLocation
}

class LocationProvider: NSObject, ObservableObject {
  lazy var locationManager: CLLocationManager = {
    let locManager = CLLocationManager()
    locManager.distanceFilter = 10
    locManager.requestWhenInUseAuthorization()
    locManager.delegate = self
    return locManager
  }()
  
  var location: CLLocation? {
    locationManager.location
  }
  var nextLocation: CLLocation? {
    didSet {
      reachedStation = false
    }
  }
  
  @Published var region: MKCoordinateRegion = .init()
  @Published var error: LocationProviderError?
  @Published var angle: Double = 0
  @Published var heading: CLHeading? = nil
  @Published var distance: Double = 0
  @Published var reachedStation: Bool = false
  
  var triggerDistance: Double = 5
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
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
      print("authorizedWhenInUse")
      start()
    default:
      self.error = .wrongAuthorization(manager.authorizationStatus)
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
  
  private func updateLocation(location: CLLocation) {
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
