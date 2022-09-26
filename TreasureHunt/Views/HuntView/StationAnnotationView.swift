//
//  StationAnnotationView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 26.09.22.
//

import SwiftUI

struct StationAnnotationView: View {
  let station: Station

  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "mappin")
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30)
        .font(.headline)
        .foregroundColor(.white)
        .padding(6)
        .background(Color.accentColor)
        .clipShape(Circle())

      Image(systemName: "triangle.fill")
        .resizable()
        .scaledToFit()
        .foregroundColor(.accentColor)
        .frame(width: 10, height: 10)
        .rotationEffect(.degrees(180))
        .offset(y: -3)
        .padding(.bottom, 40)
    }
    .overlay(alignment: .top) {
      Text(station.name)
        .font(.caption)
        .offset(y: -20)
    }
  }
}

struct StationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
      StationAnnotationView(station: Station(clCoordinate: .init(), name: "Testing"))
    }
}
