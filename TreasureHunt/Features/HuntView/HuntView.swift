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
  
  private var blurRadius: CGFloat {
    (huntManager.isNearCurrentStation || vm.mapIsShown) ? 0 : 20
  }
  
  var body: some View {
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
    }
    .disabled(vm.warningRead == false)
    .overlay {
      if vm.warningRead == false {
        TrafficWarningView(warningRead: $vm.warningRead)
          .transition(.opacity.combined(with: .scale))
          .zIndex(2)
      }
    }
    .animation(.default, value: huntManager.isNearCurrentStation)
    .alert(L10n.HuntView.EndHuntAlert.title, isPresented: $vm.endSessionAlertIsShown) {
      Button(L10n.BtnTitle.cancel, role: .cancel) {}
      Button(L10n.BtnTitle.iAmSure, role: .destructive) { dismiss.callAsFunction() }
    } message: {
      Text(L10n.HuntView.EndHuntAlert.message)
    }
    .sheet(isPresented: $huntManager.questionSheetIsShown) {
      if let station = huntManager.currentStation {
        QuestionView(station: station)
      }
    }
    .sheet(isPresented: $huntManager.introductionSheetIsShown,
           onDismiss: huntManager.setFirstStation) {
      if let introduction = huntManager.hunt.introduction {
        IntroductionView(introduction: introduction)
      }
    }
    .onAppear(perform: vm.applyIdleDimmingSetting)
    .onDisappear(perform: vm.disableIdleDimming)
  }
}

extension HuntView {
  @ViewBuilder
  private func arrowOverlay() -> some View {
    DirectionDistanceView(huntManager: huntManager)
      .shadow(radius: 5)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .opacity(vm.mapIsShown ? 0.2 : 1)
      .animation(.default, value: vm.mapIsShown)
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
  private func nextStationEndHuntButton() -> some View {
    if huntManager.isNearCurrentStation {
      let isNextStationButton = huntManager.isNearCurrentStation && !huntManager.isLastStation()

      Button(isNextStationButton
             ? L10n.HuntView.nextStationButtonTitle
             : L10n.HuntView.endHuntButtonTitle) {
        if isNextStationButton {
          huntManager.nextStationButtonTapped()
        } else {
          vm.endHuntButtonTapped()
        }
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
        nextStationEndHuntButton()
      }
      .frame(maxWidth: .infinity, alignment: .bottom)
      .padding(.bottom, 50 )
      .overlay(roundShowMapButton(), alignment: .bottomTrailing)
      .overlay(roundEndHuntButton(), alignment: .bottomLeading)
    }
  }
}
