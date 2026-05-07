import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let container = try! ModelContainer(
        for: Folk.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let mom = Folk(
        userAssignedName: "Mom",
        contactNumbers: ["+1 (555) 123-4567"],
        targetCallFrequencyInHours: 168, // weekly
        lastCallDate: Date().addingTimeInterval(-3 * 24 * 3600) // 3 days ago
    )
    mom.streak = 5

    let dad = Folk(
        userAssignedName: "Dad",
        contactNumbers: ["+1 (555) 234-5678"],
        targetCallFrequencyInHours: 168, // weekly
        lastCallDate: Date().addingTimeInterval(-6.5 * 24 * 3600) // 6.5 days ago — approaching
    )
    dad.streak = 3

    let grandma = Folk(
        userAssignedName: "Grandma",
        contactNumbers: ["+1 (555) 345-6789", "+1 (555) 345-0000"],
        targetCallFrequencyInHours: 720, // monthly
        lastCallDate: Date().addingTimeInterval(-31 * 24 * 3600) // 31 days ago — overdue
    )
    grandma.streak = 0

    let bestFriend = Folk(
        userAssignedName: "Alex",
        contactNumbers: ["+1 (555) 456-7890"],
        targetCallFrequencyInHours: 24, // daily
        lastCallDate: Date().addingTimeInterval(-2 * 3600) // 2 hours ago
    )
    bestFriend.streak = 12

    let neverCalled = Folk(
        userAssignedName: "Uncle Bob",
        contactNumbers: ["+1 (555) 567-8901"],
        targetCallFrequencyInHours: 2160 // quarterly
    )

    container.mainContext.insert(mom)
    container.mainContext.insert(dad)
    container.mainContext.insert(grandma)
    container.mainContext.insert(bestFriend)
    container.mainContext.insert(neverCalled)

    return container
}()
