//  Created by Dominik Hauser on 24.09.22.
//  
//

import RealmSwift
import SwiftUI

struct QuestionView: View {
  @Environment(\.dismiss) private var dismiss
  var station: THStation

  var body: some View {
    VStack {
      Text(L10n.HuntView.QuestionView.reachedStation(station.name))
        .font(.system(.largeTitle, design: .rounded, weight: .semibold))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)

      Spacer()
      VStack(alignment: .leading) {
        Text(L10n.HuntView.QuestionView.question)
          .font(.system(.headline, design: .rounded, weight: .bold))
          .foregroundColor(.secondary)
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

      Button(L10n.HuntView.QuestionView.doneButtonTitle, action: answeredQuestion)
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
    QuestionView(station: THStation.station)
  }
}
