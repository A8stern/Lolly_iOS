// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Assets {
  public enum Loading {
    public static let transparentCircle = ImageAsset(name: "Loading/transparentCircle")
  }
  public enum Authorization {
    public static let bottomShadow = ImageAsset(name: "authorization/bottomShadow")
    public static let promoBackground = ImageAsset(name: "authorization/promoBackground")
  }
  public enum Brand {
    public enum Gamification {
      public static let waveform = ImageAsset(name: "brand/gamification/waveform")
    }
    public enum Photos {
      public static let contactsBackground = ImageAsset(name: "brand/photos/contactsBackground")
    }
    public enum Stickers {
      public static let stickerLarge = ImageAsset(name: "brand/stickers/stickerLarge")
    }
  }
  public enum Controls {
    public static let backArrow = ImageAsset(name: "controls/backArrow")
    public enum Checkbox {
      public static let checkboxSelected = ImageAsset(name: "controls/checkboxSelected")
      public static let checkboxUnselected = ImageAsset(name: "controls/checkboxUnselected")
    }
    public static let close = ImageAsset(name: "controls/close")
    public static let nextArrow = ImageAsset(name: "controls/nextArrow")
    public static let playButton = ImageAsset(name: "controls/playButton")
  }
  public static let error = ImageAsset(name: "error")
  public enum Icons18 {
    public static let profile = ImageAsset(name: "icons18/profile")
  }
  public enum Icons24 {
    public enum Social {
      public static let apple = ImageAsset(name: "icons24/social/apple")
    }
  }
  public enum Icons29 {
    public enum Adminpanel {
      public static let administrator = ImageAsset(name: "icons29/adminpanel/administrator")
      public static let aigame = ImageAsset(name: "icons29/adminpanel/aigame")
      public static let events = ImageAsset(name: "icons29/adminpanel/events")
      public static let link = ImageAsset(name: "icons29/adminpanel/link")
      public static let loyaltycard = ImageAsset(name: "icons29/adminpanel/loyaltycard")
      public static let popup = ImageAsset(name: "icons29/adminpanel/popup")
      public static let push = ImageAsset(name: "icons29/adminpanel/push")
      public static let qr = ImageAsset(name: "icons29/adminpanel/qr")
      public static let textslider = ImageAsset(name: "icons29/adminpanel/textslider")
      public static let user = ImageAsset(name: "icons29/adminpanel/user")
    }
  }
  public static let spinner = ImageAsset(name: "spinner")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
