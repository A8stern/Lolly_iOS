// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
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
