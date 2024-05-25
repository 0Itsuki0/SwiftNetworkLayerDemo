//
//  ContentView.swift
//  NetworkLayerDemo
//
//  Created by Itsuki on 2024/05/25.
//

import SwiftUI

struct ContentView: View {
    @State var response: String = ""
    var body: some View {
        VStack(spacing: 50) {
            Text(response)
            
            Button(action: {
                let request = GetPostSingleRequest(id: "1")
                Task {
                    print(request)
                    do {
                        let response = try await request.sendRequest(responseType: GetPostSingleResponse.self)
                        
                        DispatchQueue.main.async {
                            self.response = "\(response)"
                        }

                    } catch(let error) {
                        print(error)
                    }
                }
            }, label: {
                Text("make request")
            })
        }
        
    }
}

#Preview {
    ContentView()
}
