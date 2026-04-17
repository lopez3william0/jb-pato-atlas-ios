import SwiftUI

struct AboutView: View {
    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "About",
                    title: "Independent sports companion",
                    subtitle: "Important context for users and App Review."
                )

                aboutCard(
                    title: "Independent app",
                    text: "JB Pato Atlas is an independent sports companion application. It is not affiliated with, endorsed by, or officially connected to any federation, club, or organization."
                )

                aboutCard(
                    title: "Information sources",
                    text: "Team names, match results and competition references are presented for informational purposes only and are based on publicly available sources included in the app."
                )

                aboutCard(
                    title: "Privacy",
                    text: "The app does not require an account. Saved items are stored locally on your device using on-device storage only."
                )

                aboutCard(
                    title: "Scope",
                    text: "Upcoming entries may appear as official events instead of full match pairings until pairings are publicly published."
                )
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aboutCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.92))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
