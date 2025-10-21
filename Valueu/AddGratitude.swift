import SwiftUI
import UIKit

struct TaskField: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

enum AddTaskMode: Equatable {
    case createList
    case editList(ParentList)
    case createSublist(parentID: UUID)
    case editSublist(parentID: UUID, sublist: Sublist)
}

struct AddGratitude: View {
    @EnvironmentObject var model: TasksModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedID: UUID?

    let mode: AddTaskMode

    @State private var fields: [TaskField] = [TaskField(text: "")]

    private var isEdit: Bool {
        switch mode {
        case .editList, .editSublist: return true
        default: return false
        }
    }

    var body: some View {
        let allFilled = fields.allSatisfy {
            !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

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
            .frame(height: 50)

            VStack(spacing: 20) {

                ZStack {
                    Text(isEdit ? "Edit Gratitude" : "Add Gratitude")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                        }
                        Spacer()

                        if !isEdit {
                            Button("Cancel") {
                                focusedID = nil
                                UIApplication.endEditing()
                                fields = [TaskField(text: "")]
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "000C34"))
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 8)
                .padding(.bottom)

                ScrollView {
                    VStack(spacing: 20) {
                        if isEdit {
                            TaskInputRow(
                                placeholder: "Enter the gratitude",
                                text: $fields[0].text
                            )
                            .focused($focusedID, equals: fields[0].id)
                        } else {
                            ForEach($fields) { $field in
                                TaskInputRow(
                                    placeholder: "Enter the gratitude",
                                    text: $field.text
                                )
                                .focused($focusedID, equals: field.id)
                            }

                            Button {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    let new = TaskField(text: "")
                                    fields.append(new)
                                    focusedID = new.id
                                }
                            } label: {
                                RowButtonContent(title: "Add Gratitude")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .padding(.horizontal, 24)
                        }

                        Button {
                            handleSave()
                        } label: {
                            RowButtonContent(title: "Save")
                        }
                        .buttonStyle(GreenButtonStyle())
                        .padding(.horizontal, 24)
                        .padding(.bottom)
                        .disabled(
                            isEdit
                                ? fields[0].text.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                                : !allFilled
                        )
                        .opacity(
                            (isEdit
                                ? !fields[0].text.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                                : allFilled) ? 1.0 : 0.5
                        )
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
        .onAppear {
            switch mode {
            case .createList, .createSublist:
                fields = [TaskField(text: "")]
                focusedID = fields.first?.id

            case .editList(let parent):
                fields = [TaskField(text: parent.title)]
                focusedID = fields.first?.id

            case .editSublist(_, let sub):
                fields = [TaskField(text: sub.title)]
                focusedID = fields.first?.id
            }
        }
    }

    private func handleSave() {
        let titles =
            fields
            .map(\.text)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !titles.isEmpty else { return }

        switch mode {
        case .createList:

            titles.forEach { model.addList(title: $0) }

        case .editList(let parent):
            model.editListTitle(id: parent.id, newTitle: titles.first!)

        case .createSublist(let parentID):

            titles.forEach { model.addSublist(parentID: parentID, title: $0) }

        case .editSublist(let parentID, let sub):
            model.editSublistTitle(
                parentID: parentID,
                subID: sub.id,
                newTitle: titles.first!
            )
        }

        fields = [TaskField(text: "")]
        dismiss()
    }
}

private struct TaskInputRow: View {
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "1196FD"), lineWidth: 2)
                    )
                    .frame(height: 60)

                TextField("", text: $text)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isFocused ? Color(hex: "1196FD") : .black)
                    .padding(.horizontal, 22)
                    .frame(height: 60)
                    .focused($isFocused)

                if text.isEmpty {
                    HStack {
                        Text(placeholder)
                            .foregroundColor(.black.opacity(0.4))
                            .font(.system(size: 16))
                            .padding(.leading, 22)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct RowButtonContent: View {
    let title: String
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .italic()
            HStack {
                Spacer()
                Group {
                    if title == "Add Gratitude" {
                        Image(systemName: "plus")
                    } else {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.system(size: 18, weight: .bold))
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
    }
}

extension UIApplication {
    static func endEditing() {
        #if canImport(UIKit)
            shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        #endif
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddGratitude(mode: .createList)
                .environmentObject(TasksModel())
                .previewDisplayName("Create List")

            AddGratitude(mode: .createSublist(parentID: UUID()))
                .environmentObject(TasksModel())
                .previewDisplayName("Create Sublist")

            let exampleParent = ParentList(title: "My List")
            AddGratitude(mode: .editList(exampleParent))
                .environmentObject(TasksModel())
                .previewDisplayName("Edit List")

            let exampleSub = Sublist(title: "Sub A")
            AddGratitude(
                mode: .editSublist(
                    parentID: exampleParent.id,
                    sublist: exampleSub
                )
            )
            .environmentObject(TasksModel())
            .previewDisplayName("Edit Sublist")
        }
        .environment(\.colorScheme, .dark)
    }
}
