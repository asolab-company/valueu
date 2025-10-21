import SwiftUI

enum AppStage { case loading, onboarding, main }

struct AddTaskRoute: Identifiable {
    let id = UUID()
    let mode: AddTaskMode
}

struct DetailRoute: Identifiable {
    let id = UUID()
    let listID: UUID
}

struct RootView: View {
    @StateObject private var model = TasksModel()
    @AppStorage("onboarding_done") private var onboardingDone = false
    @State private var stage: AppStage = .loading

    @State private var showSettings = false
    @State private var addRoute: AddTaskRoute? = nil
    @State private var detailRoute: DetailRoute? = nil

    var body: some View {
        Group {
            switch stage {
            case .loading:
                LoadingView { stage = onboardingDone ? .main : .onboarding }

            case .onboarding:
                OnboardingView {
                    onboardingDone = true
                    stage = .main
                }

            case .main:
                ZStack {
                    MainView(
                        onOpenSettings: { showSettings = true },
                        onOpenAddNew: { addRoute = .init(mode: .createList) },
                        onEditTask: { list in
                            addRoute = .init(mode: .editList(list))
                        },
                        onOpenDetails: { list in
                            detailRoute = .init(listID: list.id)
                        }
                    )
                    .environmentObject(model)
                }
                .fullScreenCover(isPresented: $showSettings) { SettingView() }
                .transaction { $0.disablesAnimations = true }

                .fullScreenCover(item: $addRoute) { route in
                    AddGratitude(mode: route.mode).environmentObject(model)
                }
                .transaction { $0.disablesAnimations = true }

                .fullScreenCover(item: $detailRoute) { route in
                    MainDetails(listID: route.listID)
                        .environmentObject(model)
                }
                .transaction { $0.disablesAnimations = true }
            }
        }
        .animation(.easeInOut, value: stage)
    }
}
