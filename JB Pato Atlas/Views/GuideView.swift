import SwiftUI

struct GuideView: View {
    @EnvironmentObject private var repository: AppRepository

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "Rules & context",
                    title: "Guide",
                    subtitle: "A lightweight in-app guide built from federation history, regulations and calendar notes."
                )

                NavigationLink {
                    AboutView()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("About this app")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                            Text("Disclaimer, sources and privacy summary.")
                                .font(.subheadline)
                                .foregroundStyle(JBTheme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(JBTheme.accent)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(JBTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)

                ForEach(repository.guideSections) { section in
                    GuideCard(section: section)
                }
            }
        }
        .navigationTitle("Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}
