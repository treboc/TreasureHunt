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

      switch viewModel.pageIdx {
      case .name:
        NamePage()
          .transition(.pageTransition(viewModel.isBack))
      case .intro:
        IntroductionPage()
          .transition(.pageTransition(viewModel.isBack))
      case .stations:
        StationsPicker()
          .transition(.pageTransition(viewModel.isBack))
      case .outro:
        OutroPage()
          .transition(.pageTransition(viewModel.isBack))
      }
    }
    .onChange(of: viewModel.pageIdx) { _ in
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
      Button("Back", action: viewModel.backButtonTapped)
        .buttonStyle(.bordered)
        .opacity(viewModel.pageIdx == .name ? 0 : 1)

      Spacer()
      addHuntProgressCircularView
      Spacer()

      Button("Next", action: viewModel.nextButtonTapped)
        .buttonStyle(.bordered)
        .opacity(viewModel.pageIdx == .outro ? 0 : 1)
    }
    .padding(.horizontal)
  }

  private var addHuntProgressCircularView: some View {
    let foregroundColor: Color = viewModel.isValidHunt ? .green : .accentColor

    return ZStack {
      Circle()
        .trim(from: 0, to: CGFloat(viewModel.pageIdx.rawValue + 1) * 0.25)
        .stroke(foregroundColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        .rotationEffect(.degrees(90))

      if viewModel.isValidHunt {
        Image(systemName: "checkmark")
          .font(.system(.headline, design: .rounded))
      } else {
        Text("\(viewModel.pageIdx.rawValue + 1)")
          .font(.system(.headline, design: .rounded))
      }
    }
    .foregroundColor(foregroundColor)
    .frame(height: 30)
    .animation(.default, value: viewModel.pageIdx)
  }
}
