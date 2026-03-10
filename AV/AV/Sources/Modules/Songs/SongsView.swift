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
    private enum SongsSegment: String, CaseIterable {
        case listen
        case read
    }

    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @AppStorage(AppConstants.editModeStorageKey) private var isEditModeEnabled = false
    @StateObject private var player = SongsPlayerController()
    @State private var songs: [SongItem] = []
    @State private var selectedSegment: SongsSegment = .listen

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var currentTitle: String? {
        guard let index = player.currentIndex, songs.indices.contains(index) else { return nil }
        return songs[index].title(for: language)
    }

    private var listenTitle: String { language == .telugu ? "విని పాటలు" : "Listen Songs" }
    private var readTitle: String { language == .telugu ? "చదివే పాటలు" : "Read Songs" }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if songs.isEmpty {
                    VStack(spacing: 16) {
                        Picker("", selection: $selectedSegment) {
                            Text(listenTitle).tag(SongsSegment.listen)
                            Text(readTitle).tag(SongsSegment.read)
                        }
                        .pickerStyle(.segmented)
                        .padding(.top, 6)

                        songsEmptyStateView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: AppConstants.Songs.listSpacing) {
                            Picker("", selection: $selectedSegment) {
                                Text(listenTitle).tag(SongsSegment.listen)
                                Text(readTitle).tag(SongsSegment.read)
                            }
                            .pickerStyle(.segmented)
                            .padding(.top, 6)

                            if selectedSegment == .listen {
                                listenSection
                            } else {
                                readSection
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 124)
                    }
                }
            }
            .navigationDestination(for: SongItem.self) { song in
                SongLyricsDetailView(song: song, language: language) .tabBarHidden()
            }
        }
        .safeAreaInset(edge: .bottom) {
            if selectedSegment == .listen && !songs.isEmpty {
                playbackControls
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
        }
        .onAppear {
            songs = SongItem.loadFromBundle(named: AppConstants.Songs.jsonFileName)
        }
        .onChange(of: selectedSegment) { segment in
            if segment == .read {
                player.stop()
            }
        }
    }

    private var listenSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppConstants.Songs.sectionTitle(language))
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#1D2430"))
                .padding(.top, 6)

            if songs.isEmpty {
                songsEmptyStateView
            } else {
                ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                    ZStack(alignment: .topTrailing) {
                        songRow(song: song, index: index)

                        if isEditModeEnabled {
                            deleteIconButton {
                                deleteSong(song)
                            }
                        }
                    }
                }
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

    private var readSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(language == .telugu ? "పాటల పదాలు" : "Song Lyrics")
                .font(.system(size: 23, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#1D2430"))
                .padding(.top, 6)

            if songs.isEmpty {
                songsEmptyStateView
            } else {
                ForEach(songs) { song in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(value: song) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(song.title(for: language))
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#1D2430"))

                                Text(song.lyricsText(for: language))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
                                    .lineSpacing(4)
                                    .lineLimit(2)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(isEditModeEnabled)

                        if isEditModeEnabled {
                            deleteIconButton {
                                deleteSong(song)
                            }
                        }
                    }
                }
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

    private func songRow(song: SongItem, index: Int) -> some View {
        let isCurrent = player.currentIndex == index

        return HStack(spacing: 12) {
            SongRowArt(urlString: song.imageURL)
                .frame(width: AppConstants.Songs.listRowImageSize, height: AppConstants.Songs.listRowImageSize)

            VStack(alignment: .leading, spacing: 3) {
                Text(song.title(for: language))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D2430"))
                    .lineLimit(1)

                Text(song.meta(for: language))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
                    .lineLimit(1)
            }

            Spacer()

            Text(song.duration)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))

            Button {
                player.toggleSong(at: index, songs: songs)
            } label: {
                Image(systemName: isCurrent && player.isPlaying ? AppConstants.Songs.pauseIcon : AppConstants.Songs.playIcon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: AppConstants.Songs.accentHex))
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(hex: AppConstants.Songs.cardBorderHex), lineWidth: 1))
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

    private func deleteSong(_ song: SongItem) {
        guard let deletedIndex = songs.firstIndex(where: { $0.id == song.id }) else { return }
        songs.removeAll { $0.id == song.id }
        player.handleSongDeleted(at: deletedIndex, remainingCount: songs.count)
    }

    private func deleteIconButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "trash.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color.red)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(8)
    }

    private var songsEmptyStateView: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#E8ECF1"))
                    .frame(width: 80, height: 80)

                Image(systemName: "music.note")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
            }

            Text(AppConstants.genericEmptyText(language))
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
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

    func handleSongDeleted(at deletedIndex: Int, remainingCount: Int) {
        guard let currentIndex else { return }

        if remainingCount == 0 {
            stop()
            self.currentIndex = nil
            return
        }

        if deletedIndex == currentIndex {
            stop()
            self.currentIndex = nil
        } else if deletedIndex < currentIndex {
            self.currentIndex = currentIndex - 1
        }
    }
}

private struct SongItem: Identifiable, Decodable, Hashable {
    let id = UUID()
    let title: String
    let titleTelugu: String?
    let genre: String
    let genreTelugu: String?
    let lyrics: String?
    let lyricsTelugu: String?
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

    func lyricsText(for language: AppLanguage) -> String {
        if language == .telugu, let lyricsTelugu, !lyricsTelugu.isEmpty { return lyricsTelugu }
        if let lyrics, !lyrics.isEmpty { return lyrics }
        return language == .telugu ? "ఈ పాటకు పదాలు త్వరలో చేరుస్తాం." : "Lyrics will be updated soon for this song."
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

@available(iOS 16.0, *)
private struct SongLyricsDetailView: View {
    let song: SongItem
    let language: AppLanguage

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                SongRowArt(urlString: song.imageURL)
                    .frame(height: 210)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                Text(song.title(for: language))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D2430"))

                Text(song.lyricsText(for: language))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: AppConstants.Songs.subtleHex))
                    .lineSpacing(6)
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SongsView()
    } else {
        EmptyView()
    }
}
