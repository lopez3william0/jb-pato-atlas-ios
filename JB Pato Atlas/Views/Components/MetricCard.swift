import SwiftUI

struct MetricCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(JBTheme.accent)

            Text(label)
                .font(.caption)
                .foregroundStyle(JBTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
