//
//  LLMService.swift
//  VisionLLM
//
//  Created by Ashwija on 5/3/25.
//

import SwiftUICore

class LLMService : ObservableObject{
    @Published var prompt: String = ""
    @Published var responseMessage: String = ""

    func setupLLMService(_ prompt: String) {
        // Setup code for LLM service
    
        self.fetchAPI(prompt) { [weak self] response in
            DispatchQueue.main.async {
                self?.responseMessage = response
            }
        }
        
    }
    
    func fetchAPI(_ prompt: String, completion: @escaping (String) -> Void) {
        // Fetch API response
        
        guard let url = URL(string: "http://localhost:1234/v1/chat/completions") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body :[String: Any] = [
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": -1,
            "stream": false
        ]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                if let message = decodedResponse.choices.first?.message.content {
                    DispatchQueue.main.async {
                        completion(message)
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}
    
struct APIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}
