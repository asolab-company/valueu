import Combine
import Foundation
import SwiftUI

struct Sublist: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String

    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}

struct ParentList: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var createdAt: Date
    var sublists: [Sublist]

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        sublists: [Sublist] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.sublists = sublists
    }
}

enum ListsStore {
    private static let key = "saved_parent_sublists_v1"

    static func save(_ lists: [ParentList]) {
        let data = try? JSONEncoder().encode(lists)
        UserDefaults.standard.set(data, forKey: key)
    }
    static func load() -> [ParentList] {
        guard let data = UserDefaults.standard.data(forKey: key),
            let items = try? JSONDecoder().decode([ParentList].self, from: data)
        else { return [] }
        return items
    }
    static func clear() { UserDefaults.standard.removeObject(forKey: key) }
}

final class TasksModel: ObservableObject {
    @Published var lists: [ParentList] = ListsStore.load() {
        didSet { ListsStore.save(lists) }
    }

    func addList(title: String) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        lists.append(ParentList(title: t))
    }

    func deleteList(id: UUID) {
        lists.removeAll { $0.id == id }
    }

    func editListTitle(id: UUID, newTitle: String) {
        guard let i = lists.firstIndex(where: { $0.id == id }) else { return }
        lists[i].title = newTitle
    }

    func addSublist(parentID: UUID, title: String) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, let i = lists.firstIndex(where: { $0.id == parentID })
        else { return }
        lists[i].sublists.append(Sublist(title: t))
    }

    func deleteSublist(parentID: UUID, subID: UUID) {
        guard let i = lists.firstIndex(where: { $0.id == parentID }) else {
            return
        }
        lists[i].sublists.removeAll { $0.id == subID }
    }

    func editSublistTitle(parentID: UUID, subID: UUID, newTitle: String) {
        guard let i = lists.firstIndex(where: { $0.id == parentID }) else {
            return
        }
        guard let j = lists[i].sublists.firstIndex(where: { $0.id == subID })
        else { return }
        lists[i].sublists[j].title = newTitle
    }
}
