//
//  ContentView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                // Start Game Button
                NavigationLink {
                    StartGameView()
                } label: {
                    HStack {
                        Image(systemName: "gamecontroller.fill")
                            .foregroundColor(.green)
                        Text("Start Game (Sticker Scanner)")
                            .font(.headline)
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // AR Experience Button
                NavigationLink {
                    StartGameView()
                } label: {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(.blue)
                        Text("AR Experience")
                            .font(.headline)
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
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
