//
//  SessionServiceInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

public protocol SessionServiceInterface: AnyObject {
    /// Делегат.
    var delegate: SessionServiceDelegate? { get set }

    /// Токены доступа локального пользователя.
    var userCredential: UserCredential? { get }

    /// Является ли локальный пользователь авторизованным или нет.
    var isAuthorised: Bool { get }

    /// Сохранение токенов доступа локального пользователя.
    func storeUserCredential(_ credential: UserCredential?)

    /// Запрос на получение и обновление токенов доступа для локального пользователя.
    func refreshUserCredential() async throws -> UserCredential

    /// Выход из аккаунта.
    func signOut()
}
