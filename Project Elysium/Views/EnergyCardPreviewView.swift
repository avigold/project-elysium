import SwiftUI

struct EnergyCardPreviewView: View {
    let energy: EnergyCard

    var body: some View {
        ZStack {
            cardFrame

            VStack(spacing: 10) {
                header
                artPanel
                rulesText
                Spacer(minLength: 0)
                footer
            }
            .padding(14)
        }
        .frame(width: 310, height: 430)
    }

    private var cardFrame: some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

        return ZStack {
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.95, blue: 0.88),
                            Color(red: 0.92, green: 0.86, blue: 0.74)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            shape
                .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)

            shape
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.00),
                            Color.black.opacity(0.10)
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 260
                    )
                )
                .blendMode(.multiply)
                .opacity(0.65)

            shape
                .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.45), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.20), radius: 14, x: 0, y: 10)
        .overlay(
            shape
                .inset(by: 2)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.10),
                            Color.white.opacity(0.10)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(shape)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(energy.type.displayName)
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10))
                .lineLimit(1)

            Spacer(minLength: 8)

            Text(energy.type.glyph)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10).opacity(0.95))
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.35))
                        .overlay(
                            Capsule(style: .continuous)
                                .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.35), lineWidth: 1)
                        )
                )
        }
    }

    private var artPanel: some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        return ZStack {
            shape
                .fill(.primary.opacity(0.06))

            if let nsImage = NSImage(named: artKey) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .mask(shape)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.secondary)

                    Text("Energy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 150)
                .mask(shape)
            }

            shape
                .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
        }
        .frame(height: 150)
    }

    private var boxBackground: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.white.opacity(0.28))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.22), lineWidth: 1)
            )
    }

    private var rulesText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Text")
                .font(.caption)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.65))

            Text(longText)
                .font(.system(size: 13, weight: .regular, design: .serif))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10).opacity(0.92))
                .lineLimit(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(boxBackground)
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Text("Project Elysium")
                .font(.caption2)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))

            Spacer()

            Text("Elysium • Energy")
                .font(.caption2)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))
        }
        .padding(.top, 2)
    }
    
    private var artKey: String {
        switch energy.type {
        case .soma: return "soma"
        case .nous: return "nous"
        case .eros: return "eros"
        case .thumos: return "thumos"
        case .schole: return "schole"
        }
    }

    private var longText: String {
        switch energy.type {
        case .soma:
            return """
            \(energy.type.inlineMeaning).

            Used for training, physical output, recovery work, and tasks whose limiting factor is the body.
            """
        case .nous:
            return """
            \(energy.type.inlineMeaning).

            Used for reasoning, writing, engineering, analysis, and tasks whose limiting factor is attention.
            """
        case .eros:
            return """
            \(energy.type.inlineMeaning).

            Used for social contact, emotional labour, persuasion, care, and tasks whose limiting factor is interpersonal bandwidth.
            """
        case .thumos:
            return """
            \(energy.type.inlineMeaning).

            Used for conflict, courage, boundaries, risk, and tasks whose limiting factor is aversion or pressure.
            """
        case .schole:
            return """
            \(energy.type.inlineMeaning).

            Used for planning, reflection, long-horizon thinking, and tasks whose limiting factor is time and space.
            """
        }
    }
}
