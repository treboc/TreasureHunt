//  Created by Dominik Hauser on 05/04/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SwiftUI

struct DirectionView: View {
  @ObservedObject var huntManager: HuntManager
  @Namespace private var arrow

  var body: some View {
    if huntManager.isNearCurrentLocation {
      if case .findStation(let station) = huntManager.huntState {
        NearStationView(isCompleted: station.isCompleted,
                        stationTitle: station.unwrappedTitle,
                        stationNo: huntManager.currentStationNumber,
                        stationsCount: huntManager.hunt.stationsArray.count,
                        namespace: arrow)
      }
    } else {
      NotNearstationView(stationNumber: huntManager.currentStationNumber,
                         numberOfStations: huntManager.hunt.stationsArray.count,
                         angle: huntManager.angleToCurrentStation,
                         distanceToStation: huntManager.distanceToCurrentLocation,
                         namespace: arrow)
    }
  }
}