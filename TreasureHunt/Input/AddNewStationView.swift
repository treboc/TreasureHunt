//  Created by Dominik Hauser on 21.09.22.
//  
//

import SwiftUI
import MapKit

struct AddNewStationView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var stationsStore: StationsStore

  @State var name: String = ""
  @State var region: MKCoordinateRegion

  @State private var mapIsFullscreen = false
  @Namespace private var mapNameSpace

  var body: some View {
    if mapIsFullscreen {
      fullScreenMap
    } else {
      NavigationView {

        Form {
          Section {
            Map(coordinateRegion: $region)
              .frame(height: 300)
              .matchedGeometryEffect(id: "map", in: mapNameSpace)
              .overlay(Image(systemName: "circle"))
              .overlay(alignment: .topTrailing) {
                Button(action: toggleFullscreenMap, label: {
                  Label("Minimieren", systemImage: "x.circle.fill")
                    .labelStyle(.iconOnly)
                    .padding()
                    .font(.title)
                })
                .tint(.gray)
              }
          }
          .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
          .listRowBackground(Color.clear)

          Section {
            TextField("Name", text: $name)

            Text("\(region.center.latitude), \(region.center.longitude)")
              .font(.footnote)
              .monospacedDigit()
          }

          Section {
            Button("Speichern", action: tappedSave)
            Button("Abbrechen", action: dismiss.callAsFunction)
          }
        }
        .navigationTitle("Neue Station")
      }
    }
  }
}

extension AddNewStationView {
  private var fullScreenMap: some View {
    Map(coordinateRegion: $region)
      .ignoresSafeArea()
      .matchedGeometryEffect(id: "map", in: mapNameSpace)
      .overlay(Image(systemName: "circle"))
      .overlay(alignment: .topTrailing) {
        Button(action: toggleFullscreenMap, label: {
          Label("Minimieren", systemImage: "x.circle.fill")
            .labelStyle(.iconOnly)
            .padding()
            .font(.title)
        })
        .tint(.gray)
      }
  }


  private func tappedSave() {
    stationsStore.newStation(with: name, and: region.center)
    dismiss()
  }

  func toggleFullscreenMap() {
    withAnimation {
      mapIsFullscreen.toggle()
    }
  }
}

struct InputView_Previews: PreviewProvider {
  static let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 50), span: .init(latitudeDelta: 50, longitudeDelta: 50))
  static var previews: some View {
    AddNewStationView(stationsStore: StationsStore(), region: region)
  }
}
