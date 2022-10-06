//  Created by Dominik Hauser on 24.09.22.
//  
//

import SwiftUI

struct QuestionView: View {
  @Environment(\.dismiss) private var dismiss
  let station: Station

  var body: some View {
    VStack {
      Text("\(station.name) erreicht!")
        .font(.system(.largeTitle, design: .rounded, weight: .semibold))

      Spacer()
      VStack(alignment: .leading) {
        Text("Frage")
          .font(.system(.headline, design: .rounded, weight: .bold))
          .foregroundColor(.secondary)

        Text(station.question)
          .font(.system(.title, design: .rounded, weight: .semibold))
      }
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.ultraThinMaterial)
          .shadow(radius: 5, y: 5)
      )
      Spacer()

      Button("Frage beantwortet!", action: dismiss.callAsFunction)
        .foregroundColor(Color(uiColor: .systemBackground))
        .padding(50)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .shadow(radius: 5)
    }
    .padding(.horizontal)
  }
}

struct QuestionView_Previews: PreviewProvider {
  static let station = Station(id: .init(),
                               clCoordinate: .init(latitude: -20, longitude: -50),
                               triggerDistance: 15,
                               name: "Testing",
                               question: "Wie ist das Wetter heute?")

  static var previews: some View {
    QuestionView(station: station)
  }
}
