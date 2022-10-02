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
    locManager.distanceFilter = 5
    locManager.headingFilter = 2
    locManager.requestWhenInUseAuthorization()
    locManager.desiredAccuracy = kCLLocationAccuracyBest
    locManager.delegate = self
    return locManager
  }()

  var currentLocation: CLLocation? {
    locationManager.location
  }

  var currentStationLocation: CLLocation? {
    didSet {
      reachedStation = false
    }
  }

  @Published var error: LocationProviderError?
  @Published var angle: Double = 0
  @Published var distance: Double = 0
  @Published var reachedStation: Bool = false

  var triggerDistance: Double = 5
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
    locationManager.requestLocation()
  }
  
  func start() {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  func stop() {
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
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
      updateDistance(location: location, nextLocation: currentStationLocation)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    updateAngle(heading: newHeading)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error \(error)")
  }

  private func update(heading: CLHeading?) {
    updateAngle(heading: heading)
  }
  
  func updateAngle(heading: CLHeading?) {
    if let coordinate = currentStationLocation?.coordinate,
       let myCoordinate = currentLocation?.coordinate,
       let heading = heading {

      let bearing = myCoordinate.bearing(to: coordinate)
      angle = bearing - heading.magneticHeading
    }
  }
  
  func updateDistance(location: CLLocation?, nextLocation: CLLocation?) {
    if let location = location,
       let nextLocation = nextLocation {

      distance = location.distance(from: nextLocation)
    }
  }

  func distanceTo(_ location: CLLocation) -> CLLocationDistance? {
    self.currentLocation?.distance(from: location)
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
