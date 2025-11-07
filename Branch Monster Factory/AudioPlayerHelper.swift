//
//  AudioPlayerHelper.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/6/25.
//

import AVFoundation

class AudioPlayerHelper {
    // Note: The player must be a class property so it doesn't get deallocated
    private var audioPlayer: AVAudioPlayer?

    /// Plays a sound file from the main bundle.
    /// - Parameters:
    ///   - sound: The name of the sound file (e.g., "levelup_chime").
    ///   - type: The file extension (e.g., "mp3", "wav").
    func playSound(sound: String, type: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: type) else {
            print("Sound file not found: \(sound).\(type)")
            return
        }

        do {
            // Configure the audio session to allow playback
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Initialize and play the sound
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
