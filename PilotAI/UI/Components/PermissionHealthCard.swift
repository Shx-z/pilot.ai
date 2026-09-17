import SwiftUI

public struct PermissionHealthCard: View {
    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "shield.checkmark.fill")
                    .foregroundColor(.green)
                Text("iOS Runtime Status")
                    .font(.headline)
            }
            Text("Eta is running in standard iOS application sandbox mode. All agent tools comply with iOS permissions.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}
