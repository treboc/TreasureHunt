//
//  HuntView+BackgroundMapView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 19.12.22.
//

import MapKit
import SwiftUI

extension HuntView {
  struct BackgroundMapView: View {
    let showsMap: Bool

    @State private var region = MKCoordinateRegion(center: .init(),
                                                   latitudinalMeters: 100,
                                                   longitudinalMeters: 100)

    var body: some View {
      Map(coordinateRegion: $region,
          showsUserLocation: true,
          userTrackingMode: .constant(.follow))
      .ignoresSafeArea()
      .allowsHitTesting(false)
      .blur(radius: showsMap ? 0 : 20)
      .animation(.default, value: showsMap)
    }
  }
}

#if DEBUG
struct BackgroundMapView_Previews: PreviewProvider {
  static var previews: some View {
    HuntView.BackgroundMapView(showsMap: true)
  }
}
#endif