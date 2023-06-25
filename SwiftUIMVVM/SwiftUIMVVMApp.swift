//
//  SwiftUIMVVMApp.swift
//  SwiftUIMVVM
//
//  Created by Ayemere  Odia  on 2023/06/25.
//

import SwiftUI

@main
struct SwiftUIMVVMApp: App {
    let viewModel = BooksViewModel()
    var body: some Scene {
        WindowGroup {
            BookList(viewModel: viewModel)
        }
    }
}
