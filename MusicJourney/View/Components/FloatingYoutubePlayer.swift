//
//  FloatingYoutubePlayer.swift
//  MusicJourney
//

import SwiftUI

struct FloatingYoutubePlayer: View {

    @ObservedObject var viewModel: FloatingPlayerViewModel

    private let miniWidth: CGFloat = 200
    private let miniHeight: CGFloat = 112 // 16:9 of 200

    var body: some View {
        GeometryReader { geo in
            if let videoID = viewModel.videoID {
                let expandedWidth = geo.size.width - 32
                let expandedHeight = expandedWidth * 9 / 16

                let playerWidth  = viewModel.isExpanded ? expandedWidth  : miniWidth
                let playerHeight = viewModel.isExpanded ? expandedHeight : miniHeight

                // Anchor: bottom-right corner when mini, bottom-center when expanded
                let baseX: CGFloat = viewModel.isExpanded
                    ? (geo.size.width - expandedWidth) / 2
                    : geo.size.width - miniWidth - 16

                let baseY: CGFloat = viewModel.isExpanded
                    ? geo.size.height - expandedHeight - geo.safeAreaInsets.bottom - 16
                    : geo.size.height - miniHeight - geo.safeAreaInsets.bottom - 80

                let resolvedX = clamp(
                    baseX + viewModel.dragOffset.width,
                    min: 0,
                    max: geo.size.width - playerWidth
                )
                let resolvedY = clamp(
                    baseY + viewModel.dragOffset.height,
                    min: geo.safeAreaInsets.top,
                    max: geo.size.height - playerHeight - geo.safeAreaInsets.bottom
                )

                ZStack(alignment: .topTrailing) {
                    YouTubePlayerView(videoID: videoID)
                        .cornerRadius(12)
                        .onTapGesture {
                            viewModel.toggleExpanded()
                        }

                    Button(action: { viewModel.close() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    .padding(6)
                }
                .frame(width: playerWidth, height: playerHeight)
                .background(Color.black.opacity(0.9))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 4)
                .position(x: resolvedX + playerWidth / 2, y: resolvedY + playerHeight / 2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.dragOffset = value.translation
                        }
                        .onEnded { value in
                            let newX = baseX + value.translation.width
                            let newY = baseY + value.translation.height
                            viewModel.dragOffset = CGSize(
                                width: clamp(newX, min: 0, max: geo.size.width - playerWidth) - baseX,
                                height: clamp(newY, min: geo.safeAreaInsets.top, max: geo.size.height - playerHeight - geo.safeAreaInsets.bottom) - baseY
                            )
                        }
                )
                .animation(.spring(response: 0.35, dampingFraction: 0.82), value: viewModel.isExpanded)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(viewModel.isVisible)
    }

    private func clamp(_ value: CGFloat, min minVal: CGFloat, max maxVal: CGFloat) -> CGFloat {
        Swift.max(minVal, Swift.min(maxVal, value))
    }
}

struct FloatingYoutubePlayer_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FloatingPlayerViewModel()
        vm.openVideo(from: "https://youtu.be/dQw4w9WgXcQ")

        return ZStack {
            Color(.systemBackground).ignoresSafeArea()
            FloatingYoutubePlayer(viewModel: vm)
        }
        .previewDisplayName("FloatingYoutubePlayer")
    }
}
