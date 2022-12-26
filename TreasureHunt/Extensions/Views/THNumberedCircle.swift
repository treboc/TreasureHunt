//
//  THNumberedCircle.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 20.11.22.
//

import SwiftUI

struct THNumberedCircle: View {
  let number: Int

  var body: some View {
    Image(systemName: "\(number).circle.fill")
      .foregroundColor(.accentColor)
      .font(.title3)
  }
}

struct THNumberedCircle_Previews: PreviewProvider {
  static var previews: some View {
    THNumberedCircle(number: 1)
  }
}
