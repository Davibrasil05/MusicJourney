//
//  FloatingPlayerViewModel.swift
//  MusicJourney
//

import SwiftUI
import UIKit

// UIWindow subclass that passes touches through the transparent background,
// so only the player widget itself captures input.
final class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return hitView == rootViewController?.view ? nil : hitView
    }
}

class FloatingPlayerViewModel: ObservableObject {

    @Published var videoID: String? = nil
    @Published var isExpanded: Bool = false
    @Published var dragOffset: CGSize = .zero
    @Published var showURLInputSheet: Bool = false

    var isVisible: Bool {
        videoID != nil
    }

    // Holds the overlay window so it isn't deallocated.
    private var overlayWindow: UIWindow?

    // MARK: - Overlay window setup

    /// Creates a PassThroughWindow above the main window and hosts FloatingYoutubePlayer in it.
    /// Safe to call multiple times — installs only once.
    func installOverlayWindow() {
        guard overlayWindow == nil,
              let scene = UIApplication.shared.connectedScenes
                  .compactMap({ $0 as? UIWindowScene })
                  .first else { return }

        let window = PassThroughWindow(windowScene: scene)
        window.windowLevel = .alert - 1
        window.backgroundColor = .clear

        let hosting = UIHostingController(rootView: FloatingYoutubePlayer(viewModel: self))
        hosting.view.backgroundColor = .clear

        window.rootViewController = hosting
        window.isHidden = false
        overlayWindow = window
    }

    // MARK: - Public API

    func presentURLInput() {
        showURLInputSheet = true
    }

    /// Extracts a videoID from the URL string and opens the player.
    /// Returns an error message on failure, nil on success.
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
