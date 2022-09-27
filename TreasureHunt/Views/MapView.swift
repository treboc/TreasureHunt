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
  @Binding var radius: CLLocationDistance

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    mapView.showsUserLocation = false
    mapView.showsTraffic = false
    mapView.delegate = context.coordinator
    return mapView
  }

  func updateUIView(_ mapView: MKMapView, context: Context) {
    mapView.setRegion(region, animated: false)
    addCircle(on: mapView)
  }

  func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }

  func addCircle(on mapView: MKMapView) {
    mapView.removeOverlays(mapView.overlays)
    let circle = MKCircle(center: region.center, radius: radius)
    mapView.addOverlay(circle)
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

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let overlay = overlay as? MKCircle {
      let circleRenderer = MKCircleRenderer(circle: overlay)
      circleRenderer.lineWidth = 2
      circleRenderer.fillColor = UIColor.tintColor.withAlphaComponent(0.1)
      circleRenderer.strokeColor = .black
      return circleRenderer
    }
    return MKOverlayRenderer(overlay: overlay)
  }
}
