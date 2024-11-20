//
//  ContentView.swift
//  fake-news-detector-finale
//
//  Created by Maksym Sapaniuk on 20.11.2024.
//

import SwiftUI
import CoreML

import Foundation

func loadVocabulary() -> [String: Int]? {
    if let url = Bundle.main.url(forResource: "vocab", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let vocab = try JSONDecoder().decode([String: Int].self, from: data)
            return vocab
        } catch {
            print("Error loading vocabulary: \(error)")
        }
    }
    return nil
}

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var result: String = "Enter text to check for fake news"

    var body: some View {
        VStack(spacing: 20) {
            Text("Fake News Detection")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: checkForFakeNews) {
                Text("Check")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }

            Text(result)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // Perform fake news detection
    private func checkForFakeNews() {
        guard let vocab = loadVocabulary() else {
            result = "Failed to load vocabulary"
            return
        }
        
        guard let (inputIDs, attentionMask) = tokenizeInputText(inputText, vocab: vocab) else {
            result = "Failed to tokenize input"
            return
        }
        
        guard let model = try? FakeNewsClassifier(configuration: MLModelConfiguration()) else {
            result = "Failed to load model"
            return
        }

        let modelInput = FakeNewsClassifierInput(input_ids: inputIDs, attention_mask: attentionMask)
        
        do {
            let prediction = try model.prediction(input: modelInput)
            
            let fakeNewsScore = prediction.linear_73[0].floatValue
            let realNewsScore = prediction.linear_73[1].floatValue
            
            // Debug: Print the scores
            print("Fake News Score: \(prediction.linear_73)")
            
            result = fakeNewsScore > realNewsScore ? "Fake News Detected" : "Likely Real News"
        } catch {
            result = "Error making prediction: \(error.localizedDescription)"
        }
    }


    // Placeholder function for tokenization
    private func tokenizeInputText(_ text: String, vocab: [String: Int], maxLength: Int = 512) -> (inputIDs: MLMultiArray, attentionMask: MLMultiArray)? {
        guard let inputIDs = try? MLMultiArray(shape: [1, maxLength] as [NSNumber], dataType: .int32),
              let attentionMask = try? MLMultiArray(shape: [1, maxLength] as [NSNumber], dataType: .int32) else {
            return nil
        }
        
        // Here we need a more robust tokenization strategy
        // Split the input text into subwords (this would typically be handled by a tokenizer)
        let tokens = tokenizeUsingVocabulary(text, vocab: vocab)
        
        // Map tokens to IDs using the vocab dictionary
        var tokenIDs = tokens.prefix(maxLength).compactMap { vocab[$0] }
        
        // Pad or truncate token IDs to maxLength
        tokenIDs = Array(tokenIDs.prefix(maxLength))
        while tokenIDs.count < maxLength {
            tokenIDs.append(vocab["<pad>"] ?? 0) // Typically pad with the pad token
        }
        
        // Fill MLMultiArray for input IDs and attention mask
        for (i, tokenID) in tokenIDs.enumerated() {
            inputIDs[i] = NSNumber(value: tokenID)
            attentionMask[i] = NSNumber(value: tokenID != vocab["<pad>"] ? 1 : 0)
        }
        
        return (inputIDs, attentionMask)
    }

    private func tokenizeUsingVocabulary(_ text: String, vocab: [String: Int]) -> [String] {
        // Tokenize the input string and map each token to its subword form.
        // Here we're assuming your vocabulary is based on subword tokenization
        var tokens: [String] = []
        
        // Here you'd typically use a real tokenizer. We'll use a simple split for the sake of the example:
        let words = text.split(separator: " ").map { String($0) }
        
        for word in words {
            // Look for subword tokens in your vocab (e.g., words like "\u0120the", "\u0120and")
            if let token = vocab.keys.first(where: { word.hasPrefix($0) }) {
                tokens.append(token)
            } else {
                // If no match is found, add it as a whole word (this might be rare)
                tokens.append(word)
            }
        }
        
        return tokens
    }

}

#Preview {
    ContentView()
}
