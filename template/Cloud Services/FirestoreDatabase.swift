//
//  FirestoreDatabase.swift
//
//  Template by Pete Maiser, January 2025 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      DATE
//      YOUR_NAME
//


import Foundation
import FirebaseFirestore

struct FirestoreDatabase {

    func fetchAnnouncements() async throws -> [Announcement] {
        let today = Date()
        let startOfDay = Calendar.current.startOfDay(for: today)
        let endOfDay = Calendar.current.date(byAdding:.day, value: 1, to: startOfDay)!

        let query = Firestore.firestore().collection("announcements_v01")
          .whereField("displayStartDate", isLessThanOrEqualTo: Timestamp(date: endOfDay))
          .whereField("displayEndDate", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))

        let snapshot = try await query.getDocuments()
        let data = snapshot.documents.compactMap { document in
            try? document.data(as: Announcement.self)
        }
        return data
    }

}

// Extend Firebase DocumentReference to wrap it with async/await functionality
private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Throws an encoding error if there's a problem with our model
            // All other errors are passed to the completion handle
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
