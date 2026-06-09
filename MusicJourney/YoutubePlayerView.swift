//
//  YoutubePlayerView.swift
//  MusicJourney
//
//  Created by academy on 09/06/26.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {

    let videoID: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()

        // Permite que o vídeo rode dentro da própria tela do app.
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(
            frame: .zero,
            configuration: configuration
        )

        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard YouTubeURLParser.isValidVideoID(videoID) else {
            webView.loadHTMLString(
                "<html><body></body></html>",
                baseURL: nil
            )

            context.coordinator.loadedVideoID = nil
            return
        }

        // Evita recarregar o vídeo sempre que o SwiftUI redesenhar a tela.
        guard context.coordinator.loadedVideoID != videoID else {
            return
        }

        guard let request = makeRequest(for: videoID) else {
            return
        }

        context.coordinator.loadedVideoID = videoID
        webView.load(request)
    }

    static func dismantleUIView(
        _ webView: WKWebView,
        coordinator: Coordinator
    ) {
        // Encerra o carregamento quando o usuário sai da tela.
        webView.stopLoading()
    }

    private func makeRequest(for videoID: String) -> URLRequest? {
        var components = URLComponents(
            string: "https://www.youtube.com/embed/\(videoID)"
        )

        components?.queryItems = [
            URLQueryItem(name: "playsinline", value: "1")
        ]

        guard let url = components?.url else {
            return nil
        }

        var request = URLRequest(url: url)

        /*
         O YouTube exige que players incorporados informem a identidade
         do aplicativo por meio do cabeçalho Referer.

         Em aplicativos iOS, a orientação oficial é utilizar o Bundle ID
         no formato: https://com.exemplo.nome-do-app
         */
        if
            let bundleIdentifier = Bundle.main.bundleIdentifier?
                .lowercased(),
            let refererURL = URL(
                string: "https://\(bundleIdentifier)"
            )
        {
            request.setValue(
                refererURL.absoluteString,
                forHTTPHeaderField: "Referer"
            )
        }

        return request
    }

    final class Coordinator {
        var loadedVideoID: String?
    }
}

struct YoutubePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubePlayerView()
    }
}
