// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum Fonts {
  internal enum TTTravels {
    internal static let black = FontConvertible(name: "TTTravels-Black", family: "TT Travels", path: "TT Travels-Black.otf")
    internal static let blackItalic = FontConvertible(name: "TTTravels-BlackItalic", family: "TT Travels", path: "TT Travels-BlackItalic.otf")
    internal static let bold = FontConvertible(name: "TTTravels-Bold", family: "TT Travels", path: "TT Travels-Bold.otf")
    internal static let boldItalic = FontConvertible(name: "TTTravels-BoldItalic", family: "TT Travels", path: "TT Travels-BoldItalic.otf")
    internal static let demiBold = FontConvertible(name: "TTTravels-DemiBold", family: "TT Travels", path: "TT Travels-DemiBold.otf")
    internal static let demiBoldItalic = FontConvertible(name: "TTTravels-DemiBoldItalic", family: "TT Travels", path: "TT Travels-DemiBoldItalic.otf")
    internal static let extraBold = FontConvertible(name: "TTTravels-ExtraBold", family: "TT Travels", path: "TT Travels-ExtraBold.otf")
    internal static let extraBoldItalic = FontConvertible(name: "TTTravels-ExtraBoldItalic", family: "TT Travels", path: "TT Travels-ExtraBoldItalic.otf")
    internal static let extraLight = FontConvertible(name: "TTTravels-ExtraLight", family: "TT Travels", path: "TT Travels-ExtraLight.otf")
    internal static let extraLightItalic = FontConvertible(name: "TTTravels-ExtraLightItalic", family: "TT Travels", path: "TT Travels-ExtraLightItalic.otf")
    internal static let italic = FontConvertible(name: "TTTravels-Italic", family: "TT Travels", path: "TT Travels-Italic.otf")
    internal static let light = FontConvertible(name: "TTTravels-Light", family: "TT Travels", path: "TT Travels-Light.otf")
    internal static let lightItalic = FontConvertible(name: "TTTravels-LightItalic", family: "TT Travels", path: "TT Travels-LightItalic.otf")
    internal static let medium = FontConvertible(name: "TTTravels-Medium", family: "TT Travels", path: "TT Travels-Medium.otf")
    internal static let mediumItalic = FontConvertible(name: "TTTravels-MediumItalic", family: "TT Travels", path: "TT Travels-MediumItalic.otf")
    internal static let regular = FontConvertible(name: "TTTravels-Regular", family: "TT Travels", path: "TT Travels-Regular.otf")
    internal static let thin = FontConvertible(name: "TTTravels-Thin", family: "TT Travels", path: "TT Travels-Thin.otf")
    internal static let thinItalic = FontConvertible(name: "TTTravels-ThinItalic", family: "TT Travels", path: "TT Travels-ThinItalic.otf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, demiBold, demiBoldItalic, extraBold, extraBoldItalic, extraLight, extraLightItalic, italic, light, lightItalic, medium, mediumItalic, regular, thin, thinItalic]
  }
  internal enum Unbounded {
    internal static let black = FontConvertible(name: "Unbounded-Black", family: "Unbounded", path: "Unbounded-Black.ttf")
    internal static let bold = FontConvertible(name: "Unbounded-Bold", family: "Unbounded", path: "Unbounded-Bold.ttf")
    internal static let extraBold = FontConvertible(name: "Unbounded-ExtraBold", family: "Unbounded", path: "Unbounded-ExtraBold.ttf")
    internal static let extraLight = FontConvertible(name: "Unbounded-ExtraLight", family: "Unbounded", path: "Unbounded-ExtraLight.ttf")
    internal static let light = FontConvertible(name: "Unbounded-Light", family: "Unbounded", path: "Unbounded-Light.ttf")
    internal static let medium = FontConvertible(name: "Unbounded-Medium", family: "Unbounded", path: "Unbounded-Medium.ttf")
    internal static let regular = FontConvertible(name: "Unbounded-Regular", family: "Unbounded", path: "Unbounded-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "Unbounded-SemiBold", family: "Unbounded", path: "Unbounded-SemiBold.ttf")
    internal static let all: [FontConvertible] = [black, bold, extraBold, extraLight, light, medium, regular, semiBold]
  }
  internal static let allCustomFonts: [FontConvertible] = [TTTravels.all, Unbounded.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

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
