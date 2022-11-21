//
//  LocationAuthorizationOnboardingView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 09.10.22.
//

import SwiftUI
import CoreLocation

struct LocationAuthorizationOnboardingView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var locationProvider: LocationProvider

  private var authorizationStatus: CLAuthorizationStatus {
    locationProvider.locationManager.authorizationStatus
  }

  var body: some View {
    ZStack {
      if authorizationStatus == .denied {
        authorizationDeniedView
      }

      if authorizationStatus == .notDetermined || authorizationStatus == .restricted {
        notDeterminedView
      }
    }
    .interactiveDismissDisabled()
  }
}

struct LocationAuthorizationOnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    LocationAuthorizationOnboardingView()
  }
}

extension LocationAuthorizationOnboardingView {
  // MARK: - Denied
  private var authorizationDeniedView: some View {
    VStack(alignment: .leading, spacing: 50) {
      Text("Achtung! ⚠️")
        .font(.system(.largeTitle, design: .rounded, weight: .semibold))

      Text("Du hast die Standorterkennung für TreasureHunt deaktiviert. Diese ist aber unverzichtbar für die Nutzung der App, da die Schatzsuche standortbasiert ist.")
        .foregroundColor(.secondary)

      Image("locationAuth")
        .resizable()
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(.tint, lineWidth: 4)
        )

      VStack(alignment: .leading, spacing: 5) {
        Button {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { _ in }
          }
        } label: {
          Label("Zu den Einstellungen", systemImage: "gear")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .foregroundColor(Color(uiColor: .systemBackground))

        Text("Tippe auf den Button um zu den Einstellungen zu gelangen, gewähre den Zugriff auf deinen Standort und kehre dann zur App zurück.")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 100)
    .padding(.horizontal)
  }

  // MARK: - notGranted
  private var notDeterminedView: some View {
    VStack(alignment: .leading, spacing: 50) {
      Text("Standortfreigabe")
        .font(.system(.largeTitle, design: .rounded, weight: .semibold))

      Text("TreasureHunt benötigt deine Zustimmung um deinen Standort ermitteln zu können. Dies ist unverzichtbar um die App nutzen zu können, da die Schatzsuchen die du planen wirst, standortbasiert sind.\n\nBitte gewähre den Zugriff auf deinen Standort sowie auf die genaue Positionsbestimmung um ein möglichst gutes Erlebnis zu erhalten.")
        .foregroundColor(.secondary)

      VStack(alignment: .leading, spacing: 5) {
        Button {
          locationProvider.locationManager.requestWhenInUseAuthorization()
          locationProvider.locationManager.requestLocation()
        } label: {
          Label("Standort freigeben", systemImage: "location")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .foregroundColor(Color(uiColor: .systemBackground))

        Text("Tippe auf den Button um die Standortfreigabe zu starten.")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 100)
    .padding(.horizontal)
  }
}
