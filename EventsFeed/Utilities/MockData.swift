import Foundation
import SwiftUI

struct MockData {
    static func getConcerts() -> [Concert] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            Concert(
                id: UUID(),
                title: "Рок-концерт у Києві",
                artist: "The Rockers",
                date: calendar.date(byAdding: .day, value: 2, to: now)!,
                location: "Madison Square Garden",
                city: "Київ",
                price: 50,
                imageName: "https://picsum.photos/id/14/600/400",
                isSaved: false,
                artistID: "artist1",
                isAnnouncement: false,
                genre: "Рок"
            ),
            Concert(
                id: UUID(),
                title: "Джазовий вечір",
                artist: "Jazz Band",
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                location: "Philharmonic Hall",
                city: "Львів",
                price: 35,
                imageName: "https://picsum.photos/id/20/600/400",
                isSaved: true,
                artistID: "artist2",
                isAnnouncement: false,
                genre: "Джаз"
            ),
            Concert(
                id: UUID(),
                title: "Поп-фест у Одесі",
                artist: "Pop Stars",
                date: calendar.date(byAdding: .day, value: 5, to: now)!,
                location: "Odesa Opera House",
                city: "Одеса",
                price: 60,
                imageName: "invalid_url_will_show_placeholder",
                isSaved: false,
                artistID: "artist3",
                isAnnouncement: false,
                genre: "Поп"
            ),
            Concert(
                id: UUID(),
                title: "Електронний вечір",
                artist: "DJ Electric",
                date: calendar.date(byAdding: .day, value: 10, to: now)!,
                location: "Club Electric",
                city: "Харків",
                price: 40,
                imageName: "https://picsum.photos/id/11/600/400",
                isSaved: false,
                artistID: "artist4",
                isAnnouncement: false,
                genre: "Клуб"
            ),
            Concert(
                id: UUID(),
                title: "Анонс: 30 Seconds To Mars. Завтра буде концерт!",
                artist: "30 Seconds To Mars",
                date: calendar.date(byAdding: .day, value: 1, to: now)!,
                location: "Main Square",
                city: "Київ",
                price: 0,
                imageName: "https://picsum.photos/id/15/600/400",
                isSaved: false,
                artistID: "artist5",
                isAnnouncement: true,
                genre: "Рок"
            )
        ]
    }
    
    static func getRecommended() -> [Concert] {
        return Array(getConcerts().shuffled().prefix(3))
    }
    
    static func getUser() -> User {
        return User(
            id: "123456789",
            name: "John Doe",
            email: "john.doe@example.com",
            profileImageURL: "https://picsum.photos/200",
            givenName: "John",
            familyName: "Doe"
        )
    }
}
