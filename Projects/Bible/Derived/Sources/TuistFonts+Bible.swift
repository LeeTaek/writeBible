// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(OSX)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum BibleFontFamily {
  public enum NanumBarunGothic {
    public static let regular = BibleFontConvertible(name: "NanumBarunGothic", family: "NanumBarunGothic", path: "NanumBarunGothic.ttf")
    public static let all: [BibleFontConvertible] = [regular]
  }
  public enum NanumMyeongjo {
    public static let regular = BibleFontConvertible(name: "NanumMyeongjo", family: "NanumMyeongjo", path: "NanumMyeongjo.ttf")
    public static let all: [BibleFontConvertible] = [regular]
  }
  public enum 나눔손글씨꽃내음 {
    public static let regular = BibleFontConvertible(name: "NanumGgocNaeEum", family: "나눔손글씨 꽃내음", path: "나눔손글씨꽃내음.ttf")
    public static let all: [BibleFontConvertible] = [regular]
  }
  public static let allCustomFonts: [BibleFontConvertible] = [NanumBarunGothic.all, NanumMyeongjo.all, 나눔손글씨꽃내음.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct BibleFontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(OSX)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return Bundle.module.url(forResource: path, withExtension: nil)
  }
}

public extension BibleFontConvertible.Font {
  convenience init?(font: BibleFontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}
// swiftlint:enable all
// swiftformat:enable all
