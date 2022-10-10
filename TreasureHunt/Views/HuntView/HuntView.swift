//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI
import CoreLocation
import MapKit

struct HuntView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var huntManager: HuntManager
  @StateObject private var vm = HuntViewModel()
  
  init(hunt: Hunt) {
    _huntManager = StateObject(wrappedValue: HuntManager(hunt))
  }
  
  private var blurRadius: CGFloat {
    if huntManager.isNearCurrentStation || vm.mapIsShown {
      return 0
    }
    return 20
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Map(coordinateRegion: $vm.region,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow)
        )
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .blur(radius: blurRadius)
        .animation(.default, value: blurRadius)
        
        arrowOverlay()
        bottomButtonStack
        
        if vm.warningRead == false {
          TrafficWarningView(warningRead: $vm.warningRead)
            .transition(.opacity.combined(with: .scale))
            .zIndex(2)
        }
      }
      .animation(.default, value: huntManager.isNearCurrentStation)
      .navigationBarHidden(true)
      .alert("Bist du sicher?", isPresented: $vm.endSessionAlertIsShown) {
        Button("Abbrechen", role: .cancel) {}
        Button("Ja, beenden", role: .destructive) { dismiss.callAsFunction() }
      } message: {
        Text("Damit wird die Suche beendet, dein Fortschritt ist nicht gespeichert.")
      }
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
    .onAppear(perform: vm.applyIdleDimmingSetting)
    .onDisappear(perform: vm.disableIdleDimming)
  }
}

extension HuntView {
  @ViewBuilder
  private func arrowOverlay() -> some View {
    if let _ = huntManager.currentStation {
      DirectionDistanceView(huntManager: huntManager)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .opacity(vm.mapIsShown ? 0.2 : 1)
        .animation(.default, value: vm.mapIsShown)
    }
  }
  
  @ViewBuilder
  private func roundEndHuntButton() -> some View {
    if huntManager.isNearCurrentStation == false {
      Image(systemName: "xmark")
        .resizable()
        .padding(10)
        .background(.thinMaterial, in: Circle())
        .frame(width: 44, height: 44, alignment: .center)
        .foregroundColor(.primaryAccentColor)
        .onTapGesture(perform: vm.endHuntButtonTapped)
        .padding([.bottom, .leading], 20)
    }
  }
  
  @ViewBuilder
  private func roundShowMapButton() -> some View {
    if huntManager.isNearCurrentStation == false {
      Image(systemName: "map")
        .resizable()
        .padding(10)
        .background(.thinMaterial, in: Circle())
        .frame(width: 44, height: 44, alignment: .center)
        .foregroundColor(.primaryAccentColor)
        .pressAction(onPress: vm.showMap, onRelease: vm.hideMap)
        .padding([.bottom, .trailing], 20)
    }
  }
  
  @ViewBuilder
  private func nextStationButton() -> some View {
    if huntManager.isNearCurrentStation && huntManager.currentStationIsLastStation == false {
      Button("Nächste Station") {
        huntManager.nextStationButtonTapped()
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .foregroundColor(Color(uiColor: .systemBackground))
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    } else if huntManager.isNearCurrentStation && huntManager.currentStationIsLastStation {
      Button("Suche Beenden") {
        vm.endHuntButtonTapped()
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .foregroundColor(Color(uiColor: .systemBackground))
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
  }
  
  private var bottomButtonStack: some View {
    VStack {
      Spacer()
      HStack {
        nextStationButton()
      }
      .frame(maxWidth: .infinity, alignment: .bottom)
      .padding(.bottom, 50 )
      .overlay(roundShowMapButton(), alignment: .bottomTrailing)
      .overlay(roundEndHuntButton(), alignment: .bottomLeading)
    }
  }
}
