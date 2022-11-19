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
    locManager.desiredAccuracy = kCLLocationAccuracyBest
    locManager.delegate = self
    return locManager
  }()

  @Published var currentLocation: CLLocation?
  @Published var lastLocationUpdate: Date?
  @Published var currentStationLocation: CLLocation?

  @Published var error: LocationProviderError?
  @Published var angle: Double = 0
  @Published var distance: Double = 0
  @Published var triggerDistance: Double = 0

  private var cancellables = Set<AnyCancellable>()

  override init() {
    super.init()
    loadLastLocation()
  }
  
  func start() {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  func stop() {
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
  }

  func didChange(_ station: THStation) {
    if let location = station.location {
      currentStationLocation = location.location
      triggerDistance = location.triggerDistance
      distance = distanceTo(location.location) ?? 0
      start()
    }
  }

  func checkLocationAuthorization(locationOnboardingIsShown: inout Bool) {
    let authStatus = locationManager.authorizationStatus

    switch authStatus {
    case .restricted, .notDetermined, .denied:
      locationOnboardingIsShown = true
    case .authorizedAlways, .authorizedWhenInUse:
      locationOnboardingIsShown = false
    @unknown default:
      return
    }
  }
}

extension LocationProvider: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .restricted, .notDetermined, .denied:
      UserDefaults.standard.set(true, forKey: UserDefaults.SettingsKeys.locationAuthViewIsShown)
      return
    case .authorizedWhenInUse, .authorizedAlways:
      print("authorizedWhenInUse")
      UserDefaults.standard.set(false, forKey: UserDefaults.SettingsKeys.locationAuthViewIsShown)
    default:
      self.error = .wrongAuthorization(manager.authorizationStatus)
      print("No authorization")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = location
      updateDistance(location: location, nextLocation: currentStationLocation)
      updateSavedLocation(location: location)
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

  func distanceTo(_ location: CLLocation?) -> CLLocationDistance? {
    if let location {
      return self.currentLocation?.distance(from: location)
    }
    return nil
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

extension LocationProvider {
  private func updateSavedLocation(location: CLLocation) {
    if lastLocationUpdate == nil {
      setLastLocation()
    }

    if let lastLocationUpdate,
       (lastLocationUpdate + 300) <= .now {
      setLastLocation()
    }

    if let currentLocation {
      if location.distance(from: currentLocation) > 50 {
        setLastLocation()
      }
    }
  }

  private func setLastLocation() {
    lastLocationUpdate = .now
    if let currentLocation {
      let lastLocation = LastLocation(latitude: currentLocation.coordinate.latitude,
                                      longitude: currentLocation.coordinate.longitude,
                                      lastUpdated: .now)
      let data = try? JSONEncoder().encode(lastLocation)
      UserDefaults.standard.set(data, forKey: "LastLocation")
    } else {
      locationManager.requestLocation()
    }
  }

  private func loadLastLocation() {
    if let data = UserDefaults.standard.data(forKey: "LastLocation"),
       let lastLocation = try? JSONDecoder().decode(LastLocation.self, from: data) {
      lastLocationUpdate = lastLocation.lastUpdated
      currentLocation = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
    } else {
      locationManager.requestLocation()
    }
  }

  struct LastLocation: Codable {
    let latitude: Double
    let longitude: Double
    let lastUpdated: Date
  }
}
