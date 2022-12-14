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
      
      Button(L10n.HuntView.TrafficWarningView.buttonTitle) {
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

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    TrafficWarningView(warningRead: .constant(false))
  }
}
