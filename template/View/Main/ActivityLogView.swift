//
//  ActivityLogView.swift
//  template
//
//  Created by Elizabeth Maiser on 7/5/25.
//

import SwiftUI
import SwiftData

struct ActivityLogView: View {
    @Query(sort: \ActivityLogEntry.timestamp, order: .reverse) var logEntries: [ActivityLogEntry]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            HStack {
                Text("Activity Log")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom)
            List {
                if logEntries.isEmpty {
                    Text("No activity logged yet.")
                } else {
                    ForEach(logEntries) { entry in
                        HStack {
                            Text(entry.event)
                            Spacer()
                            Text(entry.timestamp, style: .relative)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ActivityLogView()
        .modelContainer(for: ActivityLogEntry.self, inMemory: true)
}
