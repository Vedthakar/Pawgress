import SwiftUI

struct TaskListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tasks")
                .font(.PixelS(32).bold())
                .foregroundStyle(Color.oliveGold)

            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 34))
                    .foregroundStyle(Color.coralPink)

                Text("No synced tasks yet")
                    .font(.DMSans(.title3))
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)

                Text("Tasks will appear here once your production backend is connected and starts syncing tracked activity and reminders.")
                    .font(.DMSans(.body))
                    .foregroundStyle(Color.oliveGold.opacity(0.85))
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.ivoryWhite.opacity(0.94))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.coralPink, lineWidth: 2)
                    )
            )

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightCream.ignoresSafeArea())
        .navigationTitle("Task List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.lightCream, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        TaskListView()
    }
}
