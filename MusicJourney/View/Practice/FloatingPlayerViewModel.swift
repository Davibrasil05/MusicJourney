//
//  FloatingPlayerViewModel.swift
//  MusicJourney
//

import SwiftUI
import Combine

class FloatingPlayerViewModel: ObservableObject {

    @Published var videoID: String? = nil
    @Published var isExpanded: Bool = false
    @Published var dragOffset: CGSize = .zero
    @Published var showURLInputSheet: Bool = false

    var isVisible: Bool {
        videoID != nil
    }

    func presentURLInput() {
        showURLInputSheet = true
    }

    /// Tries to extract a valid videoID from the given URL string.
    /// Returns an error message string on failure, nil on success.
    @discardableResult
    func openVideo(from urlString: String) -> String? {
        guard let id = YouTubeURLParser.extractVideoID(from: urlString) else {
            return "URL inválida. Cole um link do YouTube válido."
        }
        videoID = id
        isExpanded = false
        dragOffset = .zero
        return nil
    }

    func close() {
        videoID = nil
        isExpanded = false
        dragOffset = .zero
    }

    func toggleExpanded() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            isExpanded.toggle()
            if isExpanded {
                dragOffset = .zero
            }
        }
    }
}
