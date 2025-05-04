//
//  ContentView.swift
//  VisionLLM
//
//  Created by Ashwija on 5/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @StateObject var service = LLMService()
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            SearchBar(text: $service.prompt, onSearchButtonClicked: {
                service.setupLLMService(service.prompt)
            })
            .padding()
            
            Button("Send Prompt") {
                service.setupLLMService(service.prompt)
            }
            .padding()

            if !service.responseMessage.isEmpty {
                Text("Response: \(service.responseMessage)")
                    .padding()
            }            
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
