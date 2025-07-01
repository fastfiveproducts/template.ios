//
//  LocalStorageSample.swift
//
//  Template by Pete Maiser, July 2024 through June 2025
//      Template v0.1.2 (June)
//      © Fast Five Products LLC, 2025
//      https://github.com/fastfiveproducts/template.ios
//      used here per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      started from template 20YY-MM-DD
//      modifications cannot be used or copied without permission from YOUR_NAME
//


import Foundation
import SwiftData

struct SampleLocalStruct: Identifiable, Equatable, Codable {
    var id = UUID()
    var paswordHint: String
    var favoriteColor: String
    var dogName: String
    
    var isValid: Bool { !favoriteColor.isEmpty && !dogName.isEmpty }
}

class SampleFileManager {
    static let shared = SampleFileManager()
    private init() {}

    private let filename = "sample_structs.json"
    
    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(filename)
    }

    func save(_ samples: [SampleLocalStruct]) {
        do {
            let data = try JSONEncoder().encode(samples)
            try data.write(to: fileURL)
        } catch {
            print("❌ Error saving samples: \(error)")
        }
    }

    func load() -> [SampleLocalStruct] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([SampleLocalStruct].self, from: data)
        } catch {
            print("⚠️ No saved data found or error reading: \(error)")
            return []
        }
    }
}


@Model
class SampleLocalObject {
    @Attribute var paswordHint: String
    @Attribute var favoriteColor: String
    @Attribute var dogName: String

    init(paswordHint: String, favoriteColor: String, dogName: String) {
        self.paswordHint = paswordHint
        self.favoriteColor = favoriteColor
        self.dogName = dogName
    }

    var isValid: Bool {
        !favoriteColor.isEmpty && !dogName.isEmpty
    }
}
