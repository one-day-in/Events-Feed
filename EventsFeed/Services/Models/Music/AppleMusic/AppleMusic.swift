import MusicKit

typealias AppleMusicTrack = Song
typealias AppleMusicPlaylist = Playlist
typealias AppleMusicAlbum = Album
typealias AppleMusicArtist = Artist

struct AppleMusicSearchResult {
    let songs: MusicItemCollection<Song>
    let albums: MusicItemCollection<Album>
    let playlists: MusicItemCollection<Playlist>
    let artists: MusicItemCollection<Artist>
}
