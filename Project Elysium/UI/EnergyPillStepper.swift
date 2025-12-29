import SwiftUI

struct EnergyPillStepper: View {
    let glyph: String
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let onChange: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Left: glyph + label
            HStack(spacing: 8) {
                Text(glyph)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
            }
            .frame(width: 180, alignment: .leading)

            // Middle: explanation blurb (inline)
            Text(blurb)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Right: click targets for - and + with big hit areas
            HStack(spacing: 10) {
                pillButton(
                    systemName: "minus",
                    isEnabled: value > range.lowerBound,
                    action: decrement
                )

                Text("\(value)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .frame(width: 30, alignment: .center)

                pillButton(
                    systemName: "plus",
                    isEnabled: value < range.upperBound,
                    action: increment
                )
            }
        }
    }

    // MARK: - Actions

    private func decrement() {
        value = max(range.lowerBound, value - 1)
        onChange()
    }

    private func increment() {
        value = min(range.upperBound, value + 1)
        onChange()
    }

    // MARK: - UI helpers

    private func pillButton(systemName: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Capsule(style: .continuous)
                    .fill(Color.elysiumPaper.opacity(isEnabled ? 0.28 : 0.16))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.elysiumInk.opacity(0.14), lineWidth: 1)
                    )

                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isEnabled ? Color.elysiumInk.opacity(0.90) : Color.elysiumInk.opacity(0.35))
            }
            .frame(width: 44, height: 30) // BIG hit target
            .contentShape(Capsule(style: .continuous)) // ensures the whole capsule is clickable
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var blurb: String {
        switch glyph {
        case "Σ": return "Strength, stamina, recovery."
        case "Ν": return "Focus, clarity, deep work."
        case "Ε": return "Intimacy, charm, romance, social warmth."
        case "Θ": return "Courage, aggression, confrontation."
        case "Χ": return "Leisure, play, unstructured time."
        default:  return "Energy requirement."
        }
    }
}
