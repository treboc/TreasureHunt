//
//  TrafficWarningView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 27.09.22.
//

import SwiftUI

struct TrafficWarningView: View {
  @Binding var warningRead: Bool

  @ViewBuilder
  var body: some View {
    if !warningRead {
      VStack(spacing: 30) {
        HStack {
          Text(L10n.HuntView.TrafficWarningView.title)
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.black)
          Spacer()
          Text("⚠️")
            .font(.largeTitle)
        }
        
        Text(L10n.HuntView.TrafficWarningView.message)
          .frame(maxWidth: .infinity, alignment: .leading)

        Button {
          withAnimation {
            warningRead = true
          }
        } label: {
          Text(L10n.HuntView.TrafficWarningView.buttonTitle)
            .foregroundColor(.label)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.accentColor)
                .shadow(radius: Constants.Shadows.firstLevel)
            )
        }
        .padding(.bottom)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .fill(.ultraThinMaterial)
          .shadow(radius: Constants.Shadows.firstLevel)
      )
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.thinMaterial)
      .ignoresSafeArea()
      .transition(.opacity)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    TrafficWarningView(warningRead: .constant(false))
  }
}
