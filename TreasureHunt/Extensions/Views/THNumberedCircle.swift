//
//  THNumberedCircle.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.11.22.
//

import SwiftUI

struct THNumberedCircle: View {
  @Environment(\.theme.tintColor) private var tintColor
  let number: Int

  var body: some View {
    Image(systemName: "\(number).circle.fill")
      .foregroundColor(tintColor)
      .font(.title3)
  }
}

struct THNumberedCircle_Previews: PreviewProvider {
  static var previews: some View {
    THNumberedCircle(number: 1)
  }
}
