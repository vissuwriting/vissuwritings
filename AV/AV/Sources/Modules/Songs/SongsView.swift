//
//  SongsView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI
import AVFoundation
import Combine

@available(iOS 16.0, *)
struct SongsView: View {
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @StateObject private var player = SongsPlayerController()
    @State private var songs: [SongItem] = []

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var currentTitle: String? {
        guard let index = player.currentIndex, songs.indices.contains(index) else { return nil }
        return songs[index].title(for: language)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppConstants.Songs.listSpacing) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(AppConstants.Songs.sectionTitle(language))
                                .font(.system(size: 23, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#1D2430"))
                                .padding(.top, 6)

                            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                                songRow(song: song, index: index)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 124)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            playbackControls
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .background(Color.clear)
        }
        .onAppear {
            songs = SongItem.loadFromBundle(named: AppConstants.Songs.jsonFileName)
        }
    }

    private func songRow(song: SongItem, index: Int) -> some View {
        let isCurrent = player.currentIndex == index

        return HStack(spacing: 12) {
            SongRowArt(urlString: song.imageURL)
                .frame(width: AppConstants.Songs.listRowImageSize, height: AppConstants.Songs.listRowImageSize)

            VStack(alignment: .leading, spacing: 3) {
                Text(song.title(for: language))
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D2430"))
                    .lineLimit(1)

                Text(song.meta(for: language))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(song.duration)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
            }

            Button {
                player.toggleSong(at: index, songs: songs)
            } label: {
                Image(systemName: isCurrent && player.isPlaying ? AppConstants.Songs.pauseIcon : AppConstants.Songs.playIcon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: AppConstants.Songs.accentHex))
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
        .padding(.vertical, 4)
    }

    private var playbackControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppConstants.Songs.nowPlayingText(songTitle: currentTitle, language: language))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))

            HStack(spacing: 10) {
                Button {
                    player.togglePrimaryPlayPause(songs: songs)
                } label: {
                    Label(
                        player.isPlaying ? AppConstants.Songs.pauseTitle(language) : AppConstants.Songs.playTitle(language),
                        systemImage: player.isPlaying ? AppConstants.Songs.pauseIcon : AppConstants.Songs.playIcon
                    )
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#3F9BFA"), Color(hex: "#2E78D1")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Button {
                    player.stop()
                } label: {
                    Label(AppConstants.Songs.stopTitle(language), systemImage: AppConstants.Songs.stopIcon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#D86B6B"), Color(hex: "#B04A4A")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#EEF3FB"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1)
        )
    }
}

private struct SongRowArt: View {
    let urlString: String

    var body: some View {
        Group {
            if let url = URL(string: urlString), !urlString.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        fallback
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallback
                    @unknown default:
                        fallback
                    }
                }
            } else {
                fallback
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Songs.listRowCornerRadius))
    }

    private var fallback: some View {
        LinearGradient(
            colors: [
                Color(hex: AppConstants.Songs.defaultArtTopHex),
                Color(hex: AppConstants.Songs.defaultArtBottomHex)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private final class SongsPlayerController: ObservableObject {
    @Published var currentIndex: Int?
    @Published var isPlaying = false

    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    private var timeObserver: Any?

    deinit {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
        if let timeObserver, let player {
            player.removeTimeObserver(timeObserver)
        }
    }

    func togglePrimaryPlayPause(songs: [SongItem]) {
        guard !songs.isEmpty else { return }

        if let index = currentIndex {
            if isPlaying {
                pause()
            } else {
                resume(index: index, songs: songs)
            }
        } else {
            play(at: 0, songs: songs)
        }
    }

    func toggleSong(at index: Int, songs: [SongItem]) {
        guard songs.indices.contains(index) else { return }

        if currentIndex == index {
            if isPlaying {
                pause()
            } else {
                resume(index: index, songs: songs)
            }
        } else {
            play(at: index, songs: songs)
        }
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        isPlaying = false
    }

    private func pause() {
        player?.pause()
        isPlaying = false
    }

    private func resume(index: Int, songs: [SongItem]) {
        guard currentIndex == index else {
            play(at: index, songs: songs)
            return
        }
        player?.play()
        isPlaying = true
    }

    private func play(at index: Int, songs: [SongItem]) {
        guard songs.indices.contains(index), let url = URL(string: songs[index].audioURL) else { return }

        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
        if let timeObserver, let player {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        let item = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: item)
        player = newPlayer
        currentIndex = index
        isPlaying = true

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.playNext(songs: songs)
        }

        // Keep each song as a 10-second preview for smoother UX.
        timeObserver = newPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self else { return }
            if time.seconds >= AppConstants.Songs.previewDurationSeconds {
                self.playNext(songs: songs)
            }
        }

        newPlayer.play()
    }

    private func playNext(songs: [SongItem]) {
        guard !songs.isEmpty else { return }
        let next: Int
        if let currentIndex {
            next = (currentIndex + 1) % songs.count
        } else {
            next = 0
        }
        play(at: next, songs: songs)
    }
}

private struct SongItem: Identifiable, Decodable, Hashable {
    let id = UUID()
    let title: String
    let titleTelugu: String?
    let genre: String
    let genreTelugu: String?
    let duration: String
    let imageURL: String
    let audioURL: String

    func title(for language: AppLanguage) -> String {
        if language == .telugu, let titleTelugu, !titleTelugu.isEmpty { return titleTelugu }
        return title
    }

    func genre(for language: AppLanguage) -> String {
        if language == .telugu, let genreTelugu, !genreTelugu.isEmpty { return genreTelugu }
        return genre
    }

    func meta(for language: AppLanguage) -> String {
        genre(for: language)
    }
}

private extension SongItem {
    static func loadFromBundle(named fileName: String) -> [SongItem] {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: AppConstants.Songs.jsonFileExtension),
            let data = try? Data(contentsOf: url),
            let items = try? JSONDecoder().decode([SongItem].self, from: data)
        else {
            return []
        }
        return items
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SongsView()
    } else {
        EmptyView()
    }
}
