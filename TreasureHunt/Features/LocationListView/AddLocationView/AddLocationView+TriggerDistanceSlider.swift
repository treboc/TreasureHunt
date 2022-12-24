//
//  AddLocationView+TriggerDistanceSlider.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 16.10.22.
//

import SwiftUI

extension AddLocationView {
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
          Text(L10n.AddLocationView.TriggerDistanceSlider.minDistance)
          Spacer()
          Text(distanceString)
        }
        .font(.footnote)
        .accessibilityHidden(true)

        Text(L10n.AddLocationView.TriggerDistanceSlider.description)
          .foregroundColor(.secondary)
          .font(.caption)
          .padding(.top, 5)
      }
      .onChange(of: triggerDistance) { _ in
        HapticManager.shared.impact(style: .soft)
      }
      .padding(.vertical)
      .accessibilityLabel(L10n.AddLocationView.TriggerDistanceSlider.a11yLabel)
      .accessibilityValue(Text(L10n.AddLocationView.TriggerDistanceSlider.a11yValue(distanceString)))
      .accessibilityHint(L10n.AddLocationView.TriggerDistanceSlider.a11yHint)
    }
  }
}
