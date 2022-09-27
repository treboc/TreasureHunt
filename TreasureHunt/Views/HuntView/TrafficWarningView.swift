//
//  TrafficWarningView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 27.09.22.
//

import SwiftUI

struct TrafficWarningView: View {
  @Binding var warningRead: Bool

  var body: some View {
    ZStack {
      Color.black
        .opacity(0.5)
        .ignoresSafeArea()

      VStack(spacing: 30) {
        HStack {
          Text("Achtung")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.black)
          Spacer()
          Text("⚠️")
            .font(.largeTitle)
        }

        Text("Achte bei der Suche immer auf deine Umgebung und den Verkehr.")
          .frame(maxWidth: .infinity, alignment: .leading)

        Button("Verstanden") {
          withAnimation {
            warningRead = true
          }
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom)
      }
      .padding()
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
      .padding()
      }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    TrafficWarningView(warningRead: .constant(false))
  }
}
