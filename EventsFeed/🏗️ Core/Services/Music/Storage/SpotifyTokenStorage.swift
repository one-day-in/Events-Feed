import Foundation

// Дуже тонкий клас - вся логіка в базовому
final class SpotifyTokenStorage: BaseTokenStorage<SpotifyConstants> {
    // Додаємо публічний ініціалізатор
    override init() {
        super.init()
    }
}
