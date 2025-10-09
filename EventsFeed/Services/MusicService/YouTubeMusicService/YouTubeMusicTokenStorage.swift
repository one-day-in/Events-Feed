import Foundation

// Дуже тонкий клас - вся логіка в базовому
final class YouTubeMusicTokenStorage: BaseTokenStorage<YouTubeMusicConstants> {
    // Додаємо публічний ініціалізатор
    override init() {
        super.init()
    }
}
