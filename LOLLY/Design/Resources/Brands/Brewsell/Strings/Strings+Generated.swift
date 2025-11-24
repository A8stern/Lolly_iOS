// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AdminPanel {
    internal enum PushNotify {
      /// Отправить
      internal static let confirmationButton = L10n.tr("Localizable", "AdminPanel.PushNotify.ConfirmationButton", fallback: "Отправить")
      /// Основной текст
      internal static let inputText = L10n.tr("Localizable", "AdminPanel.PushNotify.InputText", fallback: "Основной текст")
      /// Заголовок
      internal static let inputTitle = L10n.tr("Localizable", "AdminPanel.PushNotify.InputTitle", fallback: "Заголовок")
      /// Новое пуш-уведомление
      internal static let title = L10n.tr("Localizable", "AdminPanel.PushNotify.Title", fallback: "Новое пуш-уведомление")
    }
    internal enum Section {
      /// Администраторы
      internal static let administrators = L10n.tr("Localizable", "AdminPanel.Section.Administrators", fallback: "Администраторы")
      /// AI-игра
      internal static let ai = L10n.tr("Localizable", "AdminPanel.Section.AI", fallback: "AI-игра")
      /// Мероприятия
      internal static let events = L10n.tr("Localizable", "AdminPanel.Section.Events", fallback: "Мероприятия")
      /// Адреса и ссылки
      internal static let links = L10n.tr("Localizable", "AdminPanel.Section.Links", fallback: "Адреса и ссылки")
      /// Карта лояльности
      internal static let loyaltyCard = L10n.tr("Localizable", "AdminPanel.Section.LoyaltyCard", fallback: "Карта лояльности")
      /// Информационный pop-up
      internal static let popUp = L10n.tr("Localizable", "AdminPanel.Section.PopUp", fallback: "Информационный pop-up")
      /// Отправить пуш-уведомление
      internal static let push = L10n.tr("Localizable", "AdminPanel.Section.Push", fallback: "Отправить пуш-уведомление")
      /// Сканировать QR
      internal static let qr = L10n.tr("Localizable", "AdminPanel.Section.QR", fallback: "Сканировать QR")
      /// Текстовый слайдер
      internal static let textSlider = L10n.tr("Localizable", "AdminPanel.Section.TextSlider", fallback: "Текстовый слайдер")
      /// Пользователи
      internal static let users = L10n.tr("Localizable", "AdminPanel.Section.Users", fallback: "Пользователи")
    }
    internal enum Title {
      /// AdminPanel
      internal static let functions = L10n.tr("Localizable", "AdminPanel.Title.Functions", fallback: "ФУНКЦИОНАЛ")
      /// СЕКЦИИ
      internal static let sections = L10n.tr("Localizable", "AdminPanel.Title.Sections", fallback: "СЕКЦИИ")
    }
  }
  internal enum AuthMethods {
    /// Продолжая, ты соглашаешься с Условиями использования сервиса,
    /// Политикой конфиденциальности
    internal static let conditions = L10n.tr("Localizable", "AuthMethods.Conditions", fallback: "Продолжая, ты соглашаешься с Условиями использования сервиса,\nПолитикой конфиденциальности")
    internal enum Buttons {
      /// Войти через Apple
      internal static let signInWithApple = L10n.tr("Localizable", "AuthMethods.Buttons.SignInWithApple", fallback: "Войти через Apple")
      /// AuthMethods
      internal static let signInWithPhone = L10n.tr("Localizable", "AuthMethods.Buttons.SignInWithPhone", fallback: "Войти по номеру телефона")
    }
  }
  internal enum Gamification {
    /// Поздравляем!
    internal static let congratulation = L10n.tr("Localizable", "Gamification.Congratulation", fallback: "Поздравляем!")
    /// Не удалось загрузить опрос. Попробуйте позже.
    internal static let error = L10n.tr("Localizable", "Gamification.Error", fallback: "Не удалось загрузить опрос. Попробуйте позже.")
    /// Опрос завершён
    internal static let gameEnd = L10n.tr("Localizable", "Gamification.GameEnd", fallback: "Опрос завершён")
    /// Gamification
    internal static let start = L10n.tr("Localizable", "Gamification.Start", fallback: "Начнём?")
  }
  internal enum Loyalty {
    internal enum Loading {
      /// Произошла ошибка,
      /// попробуйте позже
      internal static let error = L10n.tr("Localizable", "Loyalty.Loading.Error", fallback: "Произошла ошибка,\nпопробуйте позже")
      /// Loyalty
      internal static let success = L10n.tr("Localizable", "Loyalty.Loading.Success", fallback: "Наклейка успешно\nдобавлена на карточку")
    }
  }
  internal enum Main {
    /// Main
    internal static let title = L10n.tr("Localizable", "Main.Title", fallback: "Brewsell")
    internal enum ContactsSection {
      /// Вебсайт
      internal static let website = L10n.tr("Localizable", "Main.ContactsSection.Website", fallback: "Вебсайт")
    }
    internal enum GameSection {
      /// Нейросеть выберет
      /// напиток за тебя
      internal static let title = L10n.tr("Localizable", "Main.GameSection.Title", fallback: "Нейросеть выберет\nнапиток за тебя")
    }
  }
  internal enum Otp {
    internal enum Verification {
      /// Введите код из смс
      internal static let caption = L10n.tr("Localizable", "OTP.Verification.Caption", fallback: "Введите код из смс")
      /// OTP
      internal static let resendCode = L10n.tr("Localizable", "OTP.Verification.ResendCode", fallback: "Отправить код повторно")
      /// Перейти в Telegram-бот для авторизации
      internal static let telegram = L10n.tr("Localizable", "OTP.Verification.Telegram", fallback: "Перейти в Telegram-бот для авторизации")
    }
  }
  internal enum PhoneLogIn {
    internal enum Buttons {
      /// Продолжить
      internal static let `continue` = L10n.tr("Localizable", "PhoneLogIn.Buttons.Continue", fallback: "Продолжить")
      /// Зарегистрироваться
      internal static let register = L10n.tr("Localizable", "PhoneLogIn.Buttons.Register", fallback: "Зарегистрироваться")
    }
    internal enum Name {
      /// Иван
      internal static let placeholder = L10n.tr("Localizable", "PhoneLogIn.Name.Placeholder", fallback: "Иван")
      /// Имя
      internal static let title = L10n.tr("Localizable", "PhoneLogIn.Name.Title", fallback: "Имя")
      /// Имя должно быть длиннее 1 символа
      internal static let validationError = L10n.tr("Localizable", "PhoneLogIn.Name.ValidationError", fallback: "Имя должно быть длиннее 1 символа")
    }
    internal enum Phone {
      /// +7 913 000-00-00
      internal static let placeholder = L10n.tr("Localizable", "PhoneLogIn.Phone.Placeholder", fallback: "+7 913 000-00-00")
      /// PhoneLogIn
      internal static let title = L10n.tr("Localizable", "PhoneLogIn.Phone.Title", fallback: "Номер телефона")
    }
    internal enum Terms {
      /// договора оферты
      internal static let oferta = L10n.tr("Localizable", "PhoneLogIn.Terms.Oferta", fallback: "договора оферты")
      /// политики конфиденциальности
      internal static let privacyPolicy = L10n.tr("Localizable", "PhoneLogIn.Terms.PrivacyPolicy", fallback: "политики конфиденциальности")
      /// Я принимаю условия договора оферты и политики конфиденциальности
      internal static let text = L10n.tr("Localizable", "PhoneLogIn.Terms.Text", fallback: "Я принимаю условия договора оферты и политики конфиденциальности")
    }
  }
  internal enum Scanner {
    /// Scanner
    internal static let title = L10n.tr("Localizable", "Scanner.Title", fallback: "Поднесите телефон к считывателю")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
