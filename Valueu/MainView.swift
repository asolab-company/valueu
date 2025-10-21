import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: TasksModel
    @State private var isReorderMode = false
    @Environment(\.editMode) private var editMode
    @Environment(\.scenePhase) private var scenePhase

    var onOpenSettings: () -> Void = {}
    var onOpenAddNew: () -> Void = {}
    var onEditTask: (ParentList) -> Void = { _ in }
    var onOpenDetails: (ParentList) -> Void = { _ in }

    let listBG = Color.clear

    var body: some View {
        ZStack(alignment: .top) {

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0219DA"),
                    Color(hex: "#1299FE"),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            .frame(height: 140)

            VStack {
                HStack {
                    Button(action: {}) {
                        Image("app_ic_settings")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .opacity(0)
                    }
                    Spacer()
                    Text("My Gratitude Lists")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()

                    Button(action: onOpenSettings) {
                        Image("app_ic_settings")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }

            VStack(spacing: 0) {

                VStack(spacing: 5) {
                    Button(action: { onOpenAddNew() }) {
                        ZStack {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .opacity(0)
                                Spacer()
                                Text("Add Gratitude")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    .buttonStyle(PrimaryButtonStyle())
                }
                .frame(height: 150)

                if model.lists.isEmpty {
                    VStack {
                        Spacer()
                        EmptyTasksView()
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            if model.lists.isEmpty {
                                HStack(spacing: 10) {
                                    Image("app_ic_gratful")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 90, maxHeight: 90)
                                    Text("Your list is empty")
                                        .font(
                                            .system(size: 12, weight: .regular)
                                        )
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 24)
                                .listRowBackground(listBG)
                                .listRowSeparator(.hidden)
                            } else {
                                ForEach(
                                    Array(model.lists.enumerated()),
                                    id: \.element.id
                                ) { index, item in
                                    TaskRow(
                                        item: item,
                                        isFirst: index == 0,
                                        isLast: index == model.lists.count - 1
                                    )
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(listBG)
                                    .onTapGesture { onOpenDetails(item) }
                                    .swipeActions(
                                        edge: .trailing,
                                        allowsFullSwipe: true
                                    ) {
                                        if !isReorderMode {
                                            Button(role: .destructive) {
                                                withAnimation(.default) {
                                                    model.deleteList(
                                                        id: item.id
                                                    )
                                                }
                                            } label: {
                                                Image(systemName: "trash.fill")
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color.init(hex: "DC1F00"))
                                        }
                                    }
                                    .swipeActions(
                                        edge: .leading,
                                        allowsFullSwipe: false
                                    ) {
                                        if !isReorderMode {
                                            Button {
                                                onEditTask(item)
                                            } label: {
                                                Image(systemName: "pencil")
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color.init(hex: "DC1F00"))
                                        }
                                    }
                                    .listRowInsets(
                                        EdgeInsets(
                                            top: 0,
                                            leading: 26,
                                            bottom: 0,
                                            trailing: 26
                                        )
                                    )
                                }
                            }
                        } footer: {
                            Color.clear.frame(height: 100).listRowBackground(
                                listBG
                            )
                        }
                    }
                    .contentMargins(.top, 12, for: .scrollContent)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(listBG)
                    .environment(
                        \.editMode,
                        .constant(isReorderMode ? .active : .inactive)
                    )
                    .environment(\.defaultMinListRowHeight, 40)
                    .listRowSpacing(12)
                }
            }
        }
        .background(
            ZStack {
                Color(hex: "#1B1A1A").ignoresSafeArea()
                Image("app_bg_main")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        )

    }
}

private struct EmptyTasksView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("app_ic_gratful")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 120, maxHeight: 120)
            Text("Your list is empty")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

private struct TaskRow: View {
    let item: ParentList
    var isFirst: Bool = false
    var isLast: Bool = false

    private let borderColor = Color(hex: "1196FD")
    private let cardBG = Color(hex: "000C34")
    private let corner: CGFloat = 10

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Text("\(item.sublists.count)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(borderColor)

                Text(restTitle(from: item.title))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                Text(dateString(item.createdAt))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(borderColor)
                    .monospacedDigit()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(cardBG)
        )
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .contentShape(Rectangle())
    }

    private func dateString(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "d.MM.yyyy"
        return df.string(from: date)
    }

    private func restTitle(from text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        return trimmed
    }
}
