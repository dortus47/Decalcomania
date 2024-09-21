//
//  ContentView.swift
//  Decalcomania
//
//  Created by 장은석 on 8/24/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            List(items, id: \.self, selection: $selectedItem) { item in
                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    .tag(item)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedItem = selectedItem {
                ImageView()
                // 다른 항목들을 보여주고 싶다면, selectedItem을 사용해 추가 정보를 여기에 표시할 수 있습니다.
            } else {
                Text("Select an item")
            }
        }
        .onChange(of: items) { newItems in
            // 아이템이 삭제되었을 때 선택된 항목을 자동으로 해제합니다.
            guard let selectedItem = selectedItem else { return }
            
            if !items.contains(selectedItem) {
                self.selectedItem = nil
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
