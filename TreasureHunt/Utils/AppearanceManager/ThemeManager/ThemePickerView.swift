//
//  ThemePickerView.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 28.12.22.
//

import SwiftUI

struct ThemePickerView: View {
  @ObservedObject private var themeManager = ThemeManager.shared
  @Namespace private var arrowOverlayNamespace

  var body: some View {
    VStack(alignment: .leading) {
      Text(L10n.SettingsView.ThemePickerView.accentColorDescription)
      ScrollView(.horizontal) {
        HStack {
          ForEach(ThemeManager.Theme.allCases) { theme in
            let isCurrentTheme: Bool = themeManager.currentThemeIsEqual(to: theme)

            ThemePickerItemView(theme: theme,
                                isCurrentTheme: isCurrentTheme,
                                namespaceID: arrowOverlayNamespace.self
            ) { theme in
              themeManager.setTheme(to: theme)
            }
          }
        }
      }
    }
  }
}

extension ThemePickerView {
  struct ThemePickerItemView: View {
    let theme: ThemeManager.Theme
    let isCurrentTheme: Bool
    let namespaceID: Namespace.ID
    let onTap: (ThemeManager.Theme) -> Void

    private var overlayColor: Color {
      theme.tintColor.isDarkColor ? .primary : .primaryBackground
    }

    var body: some View {
      Circle()
        .fill(theme.tintColor.gradient)
        .frame(width: 30, height: 30)
        .onTapGesture {
          withAnimation(.interpolatingSpring(stiffness: 170, damping: 20, initialVelocity: 0)) {
            onTap(theme)
          }
        }
        .overlay {
          if isCurrentTheme {
            ZStack {
              Image(systemName: "checkmark")
                .foregroundColor(overlayColor)
                .font(.system(size: 14))

              Circle()
                .stroke(overlayColor, lineWidth: 2)
                .frame(width: 22, height: 22)
            }
            .matchedGeometryEffect(id: namespaceID, in: namespaceID)
          }
        }
    }
  }
}

struct ThemePicker_Previews: PreviewProvider {
  static var previews: some View {
    ThemePickerView()
      .padding()
      .background(.ultraThinMaterial)
      .clipShape(
        RoundedRectangle(cornerRadius: 16)
      )
      .shadow(radius: 3)
      .padding()
      .environmentObject(ThemeManager.shared)
  }
}
