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
      if case .findStation = huntManager.huntState {
        findStationView
      }

      if case .showIntroduction = huntManager.huntState {
        IntroductionView(introduction: huntManager.hunt.introduction,
                         onDismiss: huntManager.readIntroduction)
        .zIndex(2)
        .transition(.opacity.combined(with: .scale))
      }
    }
    .onAppear(perform: vm.applyIdleDimmingSetting)
    .onDisappear(perform: vm.disableIdleDimming)
  }
}

extension HuntView {
  @ViewBuilder
  private var arrowOverlay: some View {
    DirectionDistanceView(huntManager: huntManager)
      .shadow(radius: 5)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .opacity(vm.mapIsShown ? 0.2 : 1)
      .animation(.default, value: vm.mapIsShown)
  }
  
  @ViewBuilder
  private var roundEndHuntButton: some View {
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
  private var roundShowMapButton: some View {
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
  
  private var setNextStationButton: some View {
    Button(L10n.HuntView.nextStationButtonTitle) {
      huntManager.nextStationButtonTapped()
      print("tapped")
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

  private var bottomButtonStack: some View {
    VStack {
      Spacer()
      HStack {
        if huntManager.isNearCurrentStation {
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

  private var findStationView: some View {
    ZStack {
      BackgroundMapView(isClear: huntManager.isNearCurrentStation || vm.mapIsShown)
      arrowOverlay
      bottomButtonStack
    }
    .disabled(vm.warningRead == false)
    .overlay {
      if vm.warningRead == false {
        TrafficWarningView(warningRead: $vm.warningRead)
          .transition(.opacity.combined(with: .scale))
      }
    }
    .animation(.default, value: huntManager.isNearCurrentStation)
    .alert(L10n.HuntView.EndHuntAlert.title, isPresented: $vm.endSessionAlertIsShown) {
      Button(L10n.BtnTitle.cancel, role: .cancel) {}
      Button(L10n.BtnTitle.iAmSure, role: .destructive) { dismiss.callAsFunction() }
    } message: {
      Text(L10n.HuntView.EndHuntAlert.message)
    }
  }
}
