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
    
    // METHODS
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                            .foregroundColor(book.rating <= 1 ? .red :
                                                book.rating <= 3 ? .yellow : .green)
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(book.rating <= 1 ? .red :
                                                    book.rating <= 3 ? .yellow : .green)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("BookWorm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
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
