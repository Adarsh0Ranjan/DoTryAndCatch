//
//  ContentView.swift
//  DoTryCatch
//
//  Created by Adarsh Ranjan on 05/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = DoTryCatchViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // Display all four results with their respective error-handling approaches
            TitleRow(title: "Optional Handling:", value: viewModel.title1)
            TitleRow(title: "Tuple Handling:", value: viewModel.title2)
            TitleRow(title: "Result Enum:", value: viewModel.title3)
            TitleRow(title: "Do-Try-Catch:", value: viewModel.title4)
            
            Button("Fetch Titles") {
                viewModel.fetchAllTitles()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            viewModel.fetchAllTitles()
        }
    }
}

// A reusable component to display title results
struct TitleRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .foregroundColor(value.contains("Error") ? .red : .green)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}

class DoTryCatchViewModel: ObservableObject {
    @Published var title1 = "Loading..."
    @Published var title2 = "Loading..."
    @Published var title3 = "Loading..."
    @Published var title4 = "Loading..."
    
    let manager = DoTryCatchDataManager()
    
    func fetchAllTitles() {
        // **1. Handling Optionals**
        if let fetchedTitle1 = manager.getTitle1() {
            title1 = fetchedTitle1
        } else {
            title1 = "Error: No Title"
        }
        
        // **2. Handling Tuple**
        let titleResult = manager.getTitleTitle2()
        if let fetchedTitle2 = titleResult.title {
            title2 = fetchedTitle2
        } else {
            title2 = "Error: \(titleResult.error?.localizedDescription ?? "Unknown Error")"
        }
        
        // **3. Handling Result Enum**
        switch manager.getTitle3() {
        case .success(let fetchedTitle3):
            title3 = fetchedTitle3
        case .failure(let error):
            title3 = "Error: \(error.localizedDescription)"
        }
        
        // **4. Using Do-Try-Catch**
        do {
            let fetchedTitle4 = try manager.getTitle4()
            title4 = fetchedTitle4
        } catch {
            title4 = "Error: \(error.localizedDescription)"
        }
    }
}

class DoTryCatchDataManager {
    var isActive = false  // Change to `true` to simulate success

    // **1. Returning Optional**
    func getTitle1() -> String? {
        return isActive ? "Title 1" : nil
    }
    
    // **2. Returning Tuple**
    func getTitleTitle2() -> (title: String?, error: Error?) {
        return isActive ? ("Title 2", nil) : (nil, URLError(.badURL))
    }
    
    // **3. Using Result Enum**
    func getTitle3() -> Result<String, Error> {
        return isActive ? .success("Title 3") : .failure(URLError(.badURL))
    }
    
    // **4. Throws Error (Needs Do-Try-Catch)**
    func getTitle4() throws -> String {
        if isActive {
            return "Title 4"
        } else {
            throw URLError(.badURL)
        }
    }
}
