// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  internal enum Footer {
    /// Copyright 2022 in TW
    internal static let footerCopyright = L10n.tr("Footer", "FOOTER_COPYRIGHT")
  }
  internal enum Localizable {
    /// %@ 您好！
    internal static func homeDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "HOME_DESCRIPTION", String(describing: p1))
    }
    /// 我是首頁副標題
    internal static let homeSubTitle = L10n.tr("Localizable", "HOME_SUB_TITLE")
    /// 我是首頁標題
    internal static let homeTitle = L10n.tr("Localizable", "HOME_TITLE")
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
