//
//  SettingsView.swift
//  template
//
//  Created by Elizabeth Maiser on 7/4/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkMode") var darkMode = false
    @AppStorage("soundEffects") var soundEffects = true
    var settingsKeys = ["darkMode", "soundEffects"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom)
            Toggle("Dark Mode", isOn: $darkMode)
            Toggle("Sound effects", isOn: $soundEffects)
            Button("Reset All Settings") {
                for key in settingsKeys {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
