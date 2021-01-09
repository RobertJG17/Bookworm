//
//  ContentView.swift
//  Bookworm
//
//  Created by Robert Guerra on 1/7/21.
//

import SwiftUI

struct ContentView: View {
    
    // MANAGED OBJECT CONTEXT AND FETCHREQUEST
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(),
                  sortDescriptors: []) var books: FetchedResults<Book>
    
    // PROPERTIES
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            Text("Count: \(books.count)")
                .navigationBarTitle("Bookworm")
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.showingAddScreen.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                        })
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
