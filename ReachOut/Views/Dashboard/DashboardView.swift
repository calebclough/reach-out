import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Folk.userAssignedName) private var folks: [Folk]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddFolk = false

    private let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 60)) { _ in
                Group {
                    if folks.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(sortedFolks) { folk in
                                    NavigationLink(value: folk) {
                                        FolkTileView(folk: folk)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("ReachOut")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddFolk = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddFolk) {
                AddFolkView()
            }
            .navigationDestination(for: Folk.self) { folk in
                FolkDetailView(folk: folk)
            }
        }
    }

    /// Sort: overdue first, then approaching, then on-track
    private var sortedFolks: [Folk] {
        folks.sorted { a, b in
            let order: [FolkStatus] = [.overdue, .approaching, .onTrack]
            let aIndex = order.firstIndex(of: a.status) ?? 2
            let bIndex = order.firstIndex(of: b.status) ?? 2
            if aIndex != bIndex { return aIndex < bIndex }
            return a.userAssignedName < b.userAssignedName
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Folks Yet", systemImage: "person.2.fill")
        } description: {
            Text("Add someone you want to stay in touch with.")
        } actions: {
            Button("Add Your First Folk") {
                showingAddFolk = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(previewContainer)
}
