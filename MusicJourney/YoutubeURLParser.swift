//
//  YoutubeURLParser.swift
//  MusicJourney
//
//  Created by academy on 09/06/26.
//

import Foundation

enum YouTubeURLParser {

    /// Extrai o ID de um vídeo do YouTube a partir de uma URL ou de um ID.
    ///
    /// Formatos aceitos:
    /// - https://www.youtube.com/watch?v=dQw4w9WgXcQ
    /// - https://youtu.be/dQw4w9WgXcQ
    /// - https://www.youtube.com/shorts/dQw4w9WgXcQ
    /// - https://www.youtube.com/embed/dQw4w9WgXcQ
    /// - https://www.youtube.com/live/dQw4w9WgXcQ
    /// - dQw4w9WgXcQ
    static func extractVideoID(from input: String) -> String? {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedInput.isEmpty else {
            return nil
        }

        // Permite receber diretamente o ID do vídeo.
        if isValidVideoID(trimmedInput) {
            return trimmedInput
        }

        // URLComponents precisa de um protocolo para interpretar a URL
        // corretamente. Isso permite aceitar também "youtu.be/ID".
        let normalizedInput: String

        if trimmedInput.hasPrefix("http://") || trimmedInput.hasPrefix("https://") {
            normalizedInput = trimmedInput
        } else {
            normalizedInput = "https://\(trimmedInput)"
        }

        guard
            let components = URLComponents(string: normalizedInput),
            let host = components.host?.lowercased()
        else {
            return nil
        }

        let pathComponents = components.path
            .split(separator: "/")
            .map(String.init)

        // Exemplo: https://youtu.be/dQw4w9WgXcQ
        if host == "youtu.be" || host.hasSuffix(".youtu.be") {
            return validatedVideoID(pathComponents.first)
        }

        let isYouTubeDomain =
            host == "youtube.com" ||
            host.hasSuffix(".youtube.com") ||
            host == "youtube-nocookie.com" ||
            host.hasSuffix(".youtube-nocookie.com")

        guard isYouTubeDomain else {
            return nil
        }

        // Exemplo: https://www.youtube.com/watch?v=dQw4w9WgXcQ
        if components.path == "/watch" {
            let videoID = components.queryItems?
                .first(where: { $0.name == "v" })?
                .value

            return validatedVideoID(videoID)
        }

        // Exemplos:
        // https://www.youtube.com/embed/dQw4w9WgXcQ
        // https://www.youtube.com/shorts/dQw4w9WgXcQ
        // https://www.youtube.com/live/dQw4w9WgXcQ
        // https://www.youtube.com/v/dQw4w9WgXcQ
        let acceptedPaths = ["embed", "shorts", "live", "v"]

        if
            pathComponents.count >= 2,
            acceptedPaths.contains(pathComponents[0])
        {
            return validatedVideoID(pathComponents[1])
        }

        return nil
    }

    /// Valida se o texto possui o formato esperado para um ID do YouTube.
    ///
    /// IDs de vídeos possuem 11 caracteres e utilizam letras, números,
    /// hífen e underscore.
    static func isValidVideoID(_ videoID: String) -> Bool {
        let pattern = #"^[A-Za-z0-9_-]{11}$"#

        return videoID.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }

    private static func validatedVideoID(_ videoID: String?) -> String? {
        guard let videoID = videoID else {
            return nil
        }

        return isValidVideoID(videoID) ? videoID : nil
    }
}
