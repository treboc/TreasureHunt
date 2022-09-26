//
//  StationsListRowView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 25.09.22.
//

import MapKit
import SwiftUI

struct StationsListRowView: View {
  let position: Int?
  let station: Station

  var circleColor: Color {
    isChosen ? Color.accentColor : Color.primary
  }

  @State private var fillCircle: CGFloat = 0
  var isChosen: Bool {
    position != nil
  }

  var body: some View {
    HStack(spacing: 10) {
      ZStack {
        animatedCircle

        if let position = position {
          Text("\(position)")
            .font(.system(.headline, design: .rounded))
            .monospacedDigit()
        }
      }
      .frame(width: 40, height: 40)

      VStack(alignment: .leading, spacing: 5) {
        Text(station.name)
          .font(.title3)
          .fontWeight(.semibold)

        if !station.question.isEmpty {
          Text("**A:** *\(station.question)*")
            .foregroundColor(.secondary)
        } else {
          Text("Keine Aufgabe für diese Station gestellt.")
            .italic()
            .foregroundColor(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(.interaction, Rectangle())
  }
}

extension StationsListRowView {
  private var animatedCircle: some View {
    ZStack {
      Circle()
        .stroke(.primary, lineWidth: 3)

      Circle()
        .trim(from: 0, to: fillCircle)
        .stroke(.tint, lineWidth: 3)
        .rotationEffect(.degrees(-90))
    }
    .onChange(of: isChosen) { _ in
      withAnimation {
        if isChosen {
          fillCircle = 0
        } else {
          fillCircle = 1
        }
      }
    }
  }
}

struct StationsListRowView_Previews: PreviewProvider {
  static let station = Station(clCoordinate: .init(latitude: 20, longitude: 20), triggerDistance: 30, name: "Random", question: "This could be a wonderful question!")

  static var previews: some View {
    StationsListRowView(position: 2, station: station)
      .environmentObject(StationsStore())
      .environmentObject(LocationProvider())
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
