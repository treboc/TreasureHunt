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
  
  init(locationProvider: LocationProvider = LocationProvider(), hunt: THHunt) {
    let huntManger = HuntManager(locationProvider: locationProvider, hunt)
    _huntManager = StateObject(wrappedValue: huntManger)
  }
  
  var body: some View {
    ZStack {
      switch huntManager.huntState {
      case .findStation, .findOutline:
        FindLocationView(huntManager: huntManager,
                         showsMap: (vm.mapIsShown || huntManager.isNearCurrentLocation),
                         uiIsTranslucent: vm.mapIsShown)
        bottomButtonStack
      case .showTask(let task):
        // FIXME: - Implement Task View
        Text(task)
          .padding()
          .background(.green)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      case .showIntroduction(let introduction):
        IntroductionView(introduction: introduction,
                         onDismiss: huntManager.setFirstStation)
      case .showOutline(let outline):
        Text(outline)
      case .finished:
        Text("Finished")
      }

      TrafficWarningView(warningRead: $vm.warningRead)
    }
    .animation(.default, value: huntManager.isNearCurrentLocation)
    .alert(L10n.HuntView.EndHuntAlert.title, isPresented: $vm.endSessionAlertIsShown) {
      Button(L10n.BtnTitle.cancel, role: .cancel) {}
      Button(L10n.BtnTitle.iAmSure, role: .destructive) { dismiss.callAsFunction() }
    } message: {
      Text(L10n.HuntView.EndHuntAlert.message)
    }
    .onAppear(perform: vm.applyIdleDimmingSetting)
    .onDisappear(perform: vm.disableIdleDimming)
  }
}

extension HuntView {
  struct FindLocationView: View {
    @ObservedObject var huntManager: HuntManager
    let showsMap: Bool
    let uiIsTranslucent: Bool

    var body: some View {
      ZStack {
        BackgroundMapView(showsMap: showsMap)
        DirectionView(huntManager: huntManager)
          .opacity(uiIsTranslucent ? 0.2 : 1)
          .animation(.default, value: uiIsTranslucent)
      }
    }
  }

  private var bottomButtonStack: some View {
    VStack {
      Spacer()
      HStack {
        if huntManager.isNearCurrentLocation {
          if huntManager.isLastStation && !huntManager.hunt.hasOutline {
            endHuntButton
          } else {
            setNextStationButton
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .bottom)
      .padding(.bottom, 50 )
      .overlay(roundShowMapButton, alignment: .bottomTrailing)
      .overlay(roundEndHuntButton, alignment: .bottomLeading)
    }
  }

  @ViewBuilder
  private var roundEndHuntButton: some View {
    if huntManager.isNearCurrentLocation == false {
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
  private var roundShowMapButton: some View {
    if huntManager.isNearCurrentLocation == false {
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
  
  private var setNextStationButton: some View {
    Button(L10n.HuntView.nextStationButtonTitle) {
      huntManager.didTapNextStationButton()
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .foregroundColor(Color(uiColor: .systemBackground))
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
  }

  private var endHuntButton: some View {
    Button(L10n.HuntView.endHuntButtonTitle) {
      vm.endHuntButtonTapped()
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .foregroundColor(Color(uiColor: .systemBackground))
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
  }
}
