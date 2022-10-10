//
//  AudioPlayer.swift
//  TreasureHunt
//
//  Created by Marvin Lee Kobert on 11.10.22.
//

import AVFoundation
import Foundation

final class AudioPlayer {
  private var player: AVAudioPlayer?
  private var playedSound: Bool = false

  private func play(type: SoundType) {
    if !playedSound {
      do {
        player = try AVAudioPlayer(contentsOf: type.fileURL)
        player?.play()
        playedSound = true
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func enteredStation() {
    play(type: .success)
  }

  func leftStation() {
    playedSound = false
  }
}
