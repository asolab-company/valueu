import Combine
import SwiftUI

struct MainDetails: View {
    @EnvironmentObject var model: TasksModel
    @State private var isReorderMode = false
    @Environment(\.editMode) private var editMode
    @AppStorage("did_show_swipe_hint") private var didShowSwipeHint = false
    @Environment(\.dismiss) private var dismiss

    let listID: UUID

    @State private var addRoute: AddTaskRoute? = nil

    let listBG = Color.clear

    private var parent: ParentList? {
        model.lists.first { $0.id == listID }
    }

    private var sublists: [Sublist] {
        parent?.sublists ?? []
    }

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
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(parent.map { dateString($0.createdAt) } ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                            .opacity(0)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }

            VStack(spacing: 0) {

                VStack(spacing: 5) {
                    Button(action: {
                        addRoute = .init(mode: .createSublist(parentID: listID))
                    }) {
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

                if !didShowSwipeHint {
                    HStack(spacing: 10) {
                        Image("app_ic_gratful")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 90, maxHeight: 90)
                        Text(
                            "Swipe left on the bar if you want to delete it.\nSwipe right if you want to change it."
                        )
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            didShowSwipeHint = true
                        }
                    }
                }

                Text(parent?.title ?? "")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)

                if sublists.isEmpty {
                    VStack {
                        Spacer()
                        EmptyTasksView()
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    if let parent {
                        List {
                            Section {
                                if parent.sublists.isEmpty {
                                    // Плейсхолдер *внутри* списка — безопасно для анимаций
                                    HStack(spacing: 10) {
                                        Image("app_ic_gratful")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 90, maxHeight: 90)
                                        Text("Your list is empty")
                                            .font(
                                                .system(
                                                    size: 12,
                                                    weight: .regular
                                                )
                                            )
                                            .foregroundColor(
                                                .white.opacity(0.8)
                                            )
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                    .padding(.vertical, 24)
                                    .listRowBackground(listBG)
                                    .listRowSeparator(.hidden)
                                } else {
                                    ForEach(parent.sublists) { sub in
                                        HStack {
                                            Text(sub.title)
                                                .foregroundColor(.white)
                                                .font(
                                                    .system(
                                                        size: 16,
                                                        weight: .bold
                                                    )
                                                )
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .bold
                                                    )
                                                )
                                                .foregroundColor(.white)
                                                .opacity(0)
                                        }
                                        .padding(.horizontal, 16)
                                        .frame(height: 60)
                                        .background(
                                            RoundedRectangle(
                                                cornerRadius: 10,
                                                style: .continuous
                                            )
                                            .fill(Color(hex: "000C34"))
                                        )
                                        .overlay(
                                            RoundedRectangle(
                                                cornerRadius: 10,
                                                style: .continuous
                                            )
                                            .stroke(
                                                Color(hex: "1196FD"),
                                                lineWidth: 1
                                            )
                                        )
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(listBG)
                                        .swipeActions(
                                            edge: .trailing,
                                            allowsFullSwipe: true
                                        ) {
                                            Button(role: .destructive) {
                                                withAnimation(.default) {
                                                    model.deleteSublist(
                                                        parentID: parent.id,
                                                        subID: sub.id
                                                    )
                                                }
                                            } label: {
                                                Image(systemName: "trash.fill")
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color.init(hex: "DC1F00"))
                                        }
                                        .swipeActions(
                                            edge: .leading,
                                            allowsFullSwipe: false
                                        ) {
                                            Button {
                                                addRoute = .init(
                                                    mode: .editSublist(
                                                        parentID: parent.id,
                                                        sublist: sub
                                                    )
                                                )
                                            } label: {
                                                Image(systemName: "pencil")
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color.init(hex: "DC1F00"))
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
                                Color.clear
                                    .frame(height: 100)
                                    .listRowBackground(listBG)
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
                    } else {
                        // Если listID не найден — оставим пустой экран
                        EmptyView()
                    }
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
        .fullScreenCover(item: $addRoute) { route in
            AddGratitude(mode: route.mode)
                .environmentObject(model)
        }
        .transaction { $0.disablesAnimations = true }
    }

    private func dateString(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "dd.MM.yyyy"
        return df.string(from: date)
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
