//
//  ContentView.swift
//  SwiftUIMVVM
//
//  Created by Ayemere  Odia  on 2023/06/25.
//

import SwiftUI
import Combine


struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookList(viewModel: BooksViewModel())
    }
}

struct BookList: View {
    @ObservedObject var viewModel: BooksViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                let index = viewModel.books.firstIndex(where: {$0.id == book.id }) ?? 0
                
                NavigationLink(destination: BookEdit(book: $viewModel.books[index])) {
                    BookView(bookItem: book)
                }
                
            }
        }
        .navigationBarTitle("Book List")
        .onAppear {
            viewModel.fetchBooks()
        }
    }
}


struct BookView: View {
    var bookItem: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text(bookItem.title)
                .font(.headline)
                .padding([.leading, .trailing], 5)
            Text(bookItem.author)
                .font(.subheadline)
                .padding([.leading, .trailing], 5)
        }
        .padding([.top, .bottom])
    }
}

class BooksViewModel: ObservableObject {
    let url = URL(string: "https://mocki.io/v1/722e7076-6405-4c54-9d0c-5b83502bb5a8")!
    @Published var books = [Book]()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBooks() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Book].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedBooks in
                self?.books = receivedBooks
                print(receivedBooks)
            }
            .store(in: &cancellables)
    }
}

struct BookEdit: View {
    @Binding var book: Book
    
    var body: some View {
        Form {
            Section(header: Text("About this Book")) {
                TextField("Title", text: $book.title)
                TextField("Authoe", text: $book.author)
            }
        }
    }
}

