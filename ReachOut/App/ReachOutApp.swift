import SwiftUI
import SwiftData
import UserNotifications

@main
struct ReachOutApp: App {
    @Environment(\.scenePhase) private var scenePhase

    let modelContainer: ModelContainer
    let notificationDelegate = AppNotificationDelegate()

    init() {
        let schema = Schema([Folk.self])
        let config = ModelConfiguration(schema: schema)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        UNUserNotificationCenter.current().delegate = notificationDelegate
        NotificationService.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(modelContainer)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                rescheduleAllNotifications()
            }
        }
    }

    private func rescheduleAllNotifications() {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<Folk>()
        guard let folks = try? context.fetch(descriptor) else { return }
        for folk in folks {
            NotificationService.scheduleNotification(for: folk)
        }
    }
}
