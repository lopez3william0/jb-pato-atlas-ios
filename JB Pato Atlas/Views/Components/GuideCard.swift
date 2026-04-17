import SwiftUI

struct GuideCard: View {
    let section: GuideSection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            ForEach(section.items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(JBTheme.accent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)

                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.92))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
