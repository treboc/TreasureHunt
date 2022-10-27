//
//  PagePicker.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import SwiftUI

extension AddNewStationView {
  struct PagePicker: View {
    @Binding var selectedPage: Int

    var body: some View {
      HStack {
        HStack {
          Image(systemName: selectedPage == 1 ? "mappin" : "chevron.backward")
            .frame(width: 16, height: 16)
          if selectedPage == 1 {
            Text("Position")
          }
        }
        .padding(10)
        .background(selectedPage == 1 ? Color.accentColor : Color.accentColor.opacity(0.4), in: Capsule())
        .foregroundColor(selectedPage == 1 ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
        .onTapGesture {
          selectedPage = 1
        }

        HStack {
          Image(systemName: selectedPage == 2 ? "magnifyingglass" : "chevron.forward")
            .frame(width: 16, height: 16)
          if selectedPage == 2 {
            Text("Details")
          }
        }
        .padding(10)
        .background(selectedPage == 2 ? Color.accentColor : Color.accentColor.opacity(0.4), in: Capsule())
        .foregroundColor(selectedPage == 2 ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
        .onTapGesture {
          selectedPage = 2
        }
      }
      .padding(.bottom)
    }
  }
}
