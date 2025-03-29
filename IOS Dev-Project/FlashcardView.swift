import SwiftUI

struct FlashcardView: View {
    @Binding var hasSeenFlashcard: Bool

    var body: some View {
        VStack {
            Image("earthquakeImage") // Ensure this image exists in your Assets
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // After 2 seconds, mark flashcard as seen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                hasSeenFlashcard = true
                print("FlashcardView: hasSeenFlashcard set to true")
            }
        }
    }
}

