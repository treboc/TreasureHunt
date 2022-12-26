//
//  AddHuntView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 03.10.22.
//

import Combine
import MapKit
import SwiftUI

struct AddHuntView: View {
  @StateObject var viewModel: AddHuntViewModel
  @Environment(\.dismiss) private var dismiss

  init(locationProvider: LocationProvider) {
    let viewModel = AddHuntViewModel(locationProvider: locationProvider,
                                     huntToEdit: nil)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  init(locationProvider: LocationProvider, huntToEdit: THHunt) {
    let viewModel = AddHuntViewModel(locationProvider: locationProvider, huntToEdit: huntToEdit)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      navButtonStack()

      Group {
        switch viewModel.pageIndex {
        case .name:
          NamePage()
        case .intro:
          IntroductionPage()
        case .stations:
          StationsPicker()
        case .outro:
          OutroPage()
        }
      }
      .transition(.pageTransition(viewModel.isBack))
    }
    .onChange(of: viewModel.pageIndex) { _ in
      HapticManager.shared.impact(style: .medium)
    }
    .toolbar(content: toolbarContent)
    .navigationTitle(viewModel.navTitle)
    .roundedNavigationTitle()
    .toolbar(.hidden, for: .tabBar)
    .environmentObject(viewModel)
  }
}

struct AddHuntView_Previews: PreviewProvider {
  static var previews: some View {
    AddHuntView(locationProvider: LocationProvider())
  }
}

extension AddHuntView {
  // MARK: - Views
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(L10n.BtnTitle.save) {
        viewModel.saveButtonTapped {
          dismiss()
        }
      }
      .disabled(viewModel.isValidHunt == false)
    }
  }

  private func navButtonStack() -> some View {
    HStack {
      Button(L10n.BtnTitle.back, action: viewModel.backButtonTapped)
        .buttonStyle(.bordered)
        .opacity(viewModel.pageIndex == .name ? 0 : 1)

      Spacer()
      addHuntProgressCircularView
      Spacer()

      Button(L10n.BtnTitle.next, action: viewModel.nextButtonTapped)
        .buttonStyle(.bordered)
        .opacity(viewModel.pageIndex == .outro ? 0 : 1)
    }
    .padding(.horizontal)
  }

  private var addHuntProgressCircularView: some View {
    let foregroundColor: Color = viewModel.isValidHunt ? .green : .accentColor

    return ZStack {
      Circle()
        .trim(from: 0, to: CGFloat(viewModel.pageIndex.rawValue + 1) * 0.25)
        .stroke(foregroundColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        .rotationEffect(.degrees(90))

      if viewModel.isValidHunt {
        Image(systemName: "checkmark")
          .font(.system(.headline, design: .rounded))
      } else {
        Text("\(viewModel.pageIndex.rawValue + 1)")
          .font(.system(.headline, design: .rounded))
      }
    }
    .foregroundColor(foregroundColor)
    .frame(height: 30)
    .animation(.default, value: viewModel.pageIndex)
  }
}
