//
//  SuccessPopover+ViewModifier.swift
//
//  Created by Marvin Lee Kobert on 07.11.22.
//

import SwiftUI

struct SuccessPopover<PresetingOn>: View where PresetingOn: View {
  var animationDuration: Double = 0.6
  @Binding var isPresented: Bool
  var onDismiss: (() -> Void)? = nil
  let presentedOn: () -> PresetingOn

  var body: some View {
    ZStack {
      presentedOn()
        .blur(radius: isPresented ? 5 : 0)
        .allowsHitTesting(!isPresented)

      if isPresented {
        VStack {
          AnimatedCheckmark(animationDuration: animationDuration)
            .padding(50)

          Text("Location successfully saved!")
        }
        .padding(30)
        .background(
          RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.ultraThinMaterial)
            .shadow(radius: Constants.Shadows.firstLevel)
        )
        .padding(30)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            isPresented = false
            onDismiss?()
          }
        }
      }
    }
    .animation(.easeInOut(duration: animationDuration), value: isPresented)
  }
}

extension View {
  func successPopover(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) -> some View {
    SuccessPopover(isPresented: isPresented, onDismiss: onDismiss, presentedOn: {
      self
    })
  }
}
