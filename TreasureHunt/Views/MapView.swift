//
//  MapView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
  @Binding var region: MKCoordinateRegion
  @Binding var camera: MKMapCamera

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    mapView.showsUserLocation = true
    mapView.setCamera(camera, animated: false)
    mapView.showsTraffic = false
    mapView.delegate = context.coordinator
    return mapView
  }

  func updateUIView(_ mapView: MKMapView, context: Context) {
    mapView.setRegion(region, animated: false)
  }

  func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
  var mapViewController: MapView

  init(_ controller: MapView) {
    self.mapViewController = controller
  }

  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    mapViewController.region = mapView.region
  }
}
