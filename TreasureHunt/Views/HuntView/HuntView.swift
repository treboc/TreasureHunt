//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = HuntViewModel()
  @StateObject private var huntManager: HuntManager

  init(stations: [Station]) {
    _huntManager = StateObject(wrappedValue: HuntManager(stations))
  }

  var body: some View {
    NavigationView {
      Map(coordinateRegion: $huntManager.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
        .opacity(viewModel.mapIsHidden ? 0.0 : 1.0)
        .animation(.easeInOut, value: viewModel.mapIsHidden)
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .center, content: arrowOverlay)
        .overlay(alignment: .bottomTrailing, content: showMapButton)
        .overlay(alignment: .bottom, content: nextStationButton)
        .navigationTitle(huntManager.currentStation?.name ?? "")
        .sheet(isPresented: $huntManager.questionSheetIsShown, onDismiss: huntManager.setNextStation) {
          if let station = huntManager.currentStation {
            QuestionView(station: station)
          }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Beenden", action: dismiss.callAsFunction)
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HuntView(stations: [])
  }
}

extension HuntView {
  private func nextStationButton() -> some View {
    Button("Nächste Station") {
      nextStation()
    }
    .buttonStyle(.borderedProminent)
    .padding(.bottom, 50)
  }

  private func nextStation() {
    huntManager.setNextStation()

  }

  private func arrowOverlay() -> some View {
    VStack(spacing: 10) {
      if let _ = huntManager.currentStation {
        DirectionDistanceView(angle: $huntManager.angle, distance: $huntManager.distance)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }



  private func showMapButton() -> some View {
    Text("Karte?")
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 4))
      .pressAction(onPress: showMap, onRelease: hideMap)
      .frame(maxWidth: .infinity, alignment: .trailing)
  }

  private func showMap() {
    viewModel.mapIsHidden = false
  }

  private func hideMap() {
    viewModel.mapIsHidden = true
  }

}
