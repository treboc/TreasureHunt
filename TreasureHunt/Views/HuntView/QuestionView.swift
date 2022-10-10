//  Created by Dominik Hauser on 24.09.22.
//  
//

import RealmSwift
import SwiftUI

struct QuestionView: View {
  @Environment(\.dismiss) private var dismiss
  var station: Station

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

      Button("Frage beantwortet!", action: answeredQuestion)
        .foregroundColor(Color(uiColor: .systemBackground))
        .padding(50)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .shadow(radius: 5)
    }
    .padding()
    .interactiveDismissDisabled()
  }

  private func answeredQuestion() {
    station.isCompleted = true
    dismiss()
  }
}

struct QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionView(station: Station.station)
  }
}
