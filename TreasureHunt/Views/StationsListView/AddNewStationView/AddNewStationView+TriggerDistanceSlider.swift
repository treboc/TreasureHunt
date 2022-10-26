//
//  TriggerDistanceSlider.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import SwiftUI

extension AddNewStationView {
  struct TriggerDistanceSlider: View {
    @Binding var triggerDistance: Double

    private let distanceFormatter: LengthFormatter = {
      let formatter = LengthFormatter()
      formatter.unitStyle = .short
      return formatter
    }()

    private var distanceString: String {
      distanceFormatter.string(fromMeters: triggerDistance)
    }

    var body: some View {
      VStack(alignment: .leading) {
        Slider(value: $triggerDistance, in: 5...300, step: 5)

        HStack {
          Text("Min. Distanz:")
          Spacer()
          Text(distanceString)
        }
        .font(.footnote)
        .accessibilityHidden(true)

        Text("Distanz, die unterschritten werden muss, um diese Station zu aktivieren.")
          .foregroundColor(.secondary)
          .font(.caption)
          .padding(.top, 5)
      }
      .onChange(of: triggerDistance) { _ in
        HapticManager.shared.impact(style: .soft)
      }
      .padding(.vertical)
      .accessibilityLabel("Distanzslider")
      .accessibilityValue(Text("Minimale Distanz: \(distanceString)"))
      .accessibilityHint("Legt fest, ab welcher Entfernung eine Station ausgelöst wird.")
    }
  }
}
