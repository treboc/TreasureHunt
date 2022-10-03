//
//  HapticsManager.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 02.02.22.
//

import SwiftUI

class HapticManager {
  static let shared = HapticManager()

  func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }

  func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }

  func triggerFeedback(on distance: Double) {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hapticsActivated) {
      if distance < 300 && Int(distance) % 10 == 0 {
        var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle
        switch distance {
        case 0...50:
          impactStyle = .heavy
        case 51...150:
          impactStyle = .medium
        case 150...:
          impactStyle = .light
        default:
          impactStyle = .soft
        }

        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.prepare()
        generator.impactOccurred()
      }
    }
  }
}
