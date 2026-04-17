import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService
    @State private var searchText = ""
    @State private var showingAddSheet = false

    private var filteredEvents: [ScheduledEvent] {
        guard !searchText.isEmpty else { return repository.events }
        return repository.events.filter {
            $0.competition.localizedCaseInsensitiveContains(searchText)
            || $0.venue.localizedCaseInsensitiveContains(searchText)
            || $0.notes.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var filteredCustomEvents: [CustomEvent] {
        guard !searchText.isEmpty else { return savedService.customEvents }
        return savedService.customEvents.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
            || $0.venue.localizedCaseInsensitiveContains(searchText)
            || $0.notes.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "Calendar 2026",
                    title: "Official upcoming events",
                    subtitle: "Upcoming federation schedule entries plus your own saved events."
                )

                HStack(spacing: 12) {
                    TextField("Search calendar", text: $searchText)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(JBTheme.card)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
                        )
                        .foregroundStyle(.white)

                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(JBTheme.background)
                            .frame(width: 48, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(JBTheme.accent)
                            )
                    }
                    .buttonStyle(.plain)
                }

                if !filteredCustomEvents.isEmpty {
                    Text("YOUR EVENTS")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(JBTheme.accent)

                    ForEach(filteredCustomEvents) { event in
                        customEventCard(event)
                    }
                }

                Text("OFFICIAL EVENTS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                ForEach(filteredEvents) { event in
                    EventCard(
                        event: event,
                        isSaved: savedService.isEventSaved(event.id),
                        onSave: { savedService.toggleEvent(event.id) }
                    )
                }
            }
        }
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddSheet) {
            CustomEventFormView()
                .environmentObject(savedService)
        }
    }

    private func customEventCard(_ event: CustomEvent) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("YOUR EVENT")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                Spacer()

                Button(role: .destructive) {
                    savedService.deleteCustomEvent(event)
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red.opacity(0.9))
                }
                .buttonStyle(.plain)
            }

            Text(event.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text(Self.dateFormatter.string(from: event.date))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            if !event.venue.isEmpty {
                Text(event.venue)
                    .font(.subheadline)
                    .foregroundStyle(JBTheme.textSecondary)
            }

            if !event.notes.isEmpty {
                Text(event.notes)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(JBTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(JBTheme.border, lineWidth: 1)
                )
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
