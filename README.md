# Fake News Detection iOS App

This project is an iOS application built using **SwiftUI** and **CoreML** to detect fake news from a given text input. The app uses a trained machine learning model to classify the provided text as either **Fake News** or **Real News**. It also loads a vocabulary from a JSON file for tokenization, which helps in preparing the text for the model.

## Features

- **Text Input**: Users can enter a message or text to check if it is fake news.
- **Model Inference**: The app uses a pre-trained CoreML model (`FakeNewsClassifier`) to classify the text as fake or real.
- **Vocabulary Loading**: A custom vocabulary is loaded from a JSON file, which is used to tokenize the input text for classification.
- **Result Display**: Displays the result on the screen ("Fake News Detected" or "Likely Real News").

## Requirements

- Xcode
- iOS
- Swift

## How to Build and Run

1. Clone the repository or download the project files to your local machine.
2. Open the project in **Xcode**.
3. Build and run the project on a simulator or an iOS device.

## Files Overview

### `fake_news_detector_finaleApp.swift`

This is the entry point of the application. It initializes the `ContentView` and runs the app's main view.

### `ContentView.swift`

The main view of the app is built using **SwiftUI**. This view handles the user input, processes the text, and displays the classification result.

#### Key Functions in `ContentView.swift`:

1. **`loadVocabulary()`**: Loads the vocabulary from a local JSON file (`vocab.json`), which is used to tokenize input text.
2. **`checkForFakeNews()`**: The function that handles the classification of the input text. It:
   - Loads the vocabulary.
   - Tokenizes the input text into tokens (subwords).
   - Loads the trained model (`FakeNewsClassifier`).
   - Performs inference and updates the result based on the model’s output.
3. **`tokenizeInputText()`**: A placeholder function that converts the input text into tokens using the loaded vocabulary. It ensures the text is correctly formatted for the model's input.
4. **`tokenizeUsingVocabulary()`**: A helper function that tokenizes the input text by mapping words to tokens using the loaded vocabulary.
   
### User Interface (UI)

The **UI** of the app consists of:

- A **TextField** for users to input the text they want to classify.
- A **Button** that triggers the classification when clicked.
- A **Text** field to display the result: either "Fake News Detected" or "Likely Real News."

### Model and Vocabulary

The machine learning model used in the app is a CoreML model named `FakeNewsClassifier`. The model requires tokenized text as input, which is why the vocabulary is used to tokenize the input text before passing it to the model.

The vocabulary (`vocab.json`) is loaded from the app’s bundle and contains a mapping of words (or subwords) to their corresponding integer IDs.

## How to Use

1. **Enter Text**: Type any news text or message into the provided text field.
2. **Press the Check Button**: After entering the text, press the "Check" button to run the fake news detection.
3. **View the Result**: The app will classify the text and display the result: either "Fake News Detected" or "Likely Real News."
