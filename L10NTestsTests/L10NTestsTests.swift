//
//  L10NTestsTests.swift
//  L10NTestsTests
//
//  Created by ZhgChgLi on 2022/7/15.
//

import XCTest
@testable import L10NTests

class L10NTestsTests: XCTestCase {
    
    private var localizations: [Bundle: [Localization]] = [:]
    
    override func setUp() {
        super.setUp()
        
        let bundles = [Bundle(for: type(of: self))]
        
        //
        bundles.forEach { bundle in
            var localizations: [Localization] = []
            
            bundle.localizations.forEach { lang in
                var localization = Localization(lang: lang)
                
                if let lprojPath = bundle.path(forResource: lang, ofType: "lproj"),
                   let lprojBundle = Bundle(path: lprojPath) {
                    
                    let filesInLPROJ = (try? FileManager.default.contentsOfDirectory(atPath: lprojBundle.bundlePath)) ?? []
                    localization.localizableStringFiles = filesInLPROJ.compactMap { fileFullName -> L10NTestsTests.Localization.LocalizableStringFile? in
                        let fileName = URL(fileURLWithPath: fileFullName).deletingPathExtension().lastPathComponent
                        let fileExtension = URL(fileURLWithPath: fileFullName).pathExtension
                        guard fileExtension == "strings" else { return nil }
                        guard let path = lprojBundle.path(forResource: fileName, ofType: fileExtension) else { return nil }
                        
                        return L10NTestsTests.Localization.LocalizableStringFile(name: fileFullName, path: path)
                    }
                    
                    localization.localizableStringFiles.enumerated().forEach { (index, localizableStringFile) in
                        if let fileContent = try? String(contentsOfFile: localizableStringFile.path, encoding: .utf8) {
                            let lines = fileContent.components(separatedBy: .newlines)
                            let pattern = "\"(.*)\"(\\s*)(=){1}(\\s*)\"(.+)\";"
                            let regex = try? NSRegularExpression(pattern: pattern, options: [])
                            let values = lines.compactMap { line -> Localization.LocalizableStringFile.Value? in
                                let range = NSRange(location: 0, length: (line as NSString).length)
                                guard let matches = regex?.firstMatch(in: line, options: [], range: range) else { return nil }
                                let key = (line as NSString).substring(with: matches.range(at: 1))
                                let value = (line as NSString).substring(with: matches.range(at: 5))
                                return Localization.LocalizableStringFile.Value(key: key, value: value)
                            }
                            localization.localizableStringFiles[index].values = values
                        }
                    }
                    
                    localizations.append(localization)
                }
            }
            
            self.localizations[bundle] = localizations
        }
    }

    func testNoDuplicateKeysInSameFile() throws {
        localizations.forEach { (_, localizations) in
            localizations.forEach { localization in
                localization.localizableStringFiles.forEach { localizableStringFile in
                    let keys = localizableStringFile.values.map { $0.key }
                    let uniqueKeys = Set(keys)
                    XCTAssertTrue(keys.count == uniqueKeys.count, "Localized Strings File: \(localizableStringFile.path) has duplicated keys.")
                }
            }
        }
    }
    
    func testCompareWithDevLangHasMissingKey() throws {
        localizations.forEach { (bundle, localizations) in
            let developmentLang = bundle.developmentLocalization ?? "en"
            if let developmentLocalization = localizations.first(where: { $0.lang == developmentLang }) {
                let othersLocalization = localizations.filter { $0.lang != developmentLang }
                
                developmentLocalization.localizableStringFiles.forEach { developmentLocalizableStringFile in
                    let developmentLocalizableKeys = Set(developmentLocalizableStringFile.values.map { $0.key })
                    othersLocalization.forEach { otherLocalization in
                        if let otherLocalizableStringFile = otherLocalization.localizableStringFiles.first(where: { $0.name == developmentLocalizableStringFile.name }) {
                            let otherLocalizableKeys = Set(otherLocalizableStringFile.values.map { $0.key })
                            if developmentLocalizableKeys.count < otherLocalizableKeys.count {
                                XCTFail("Localized Strings File: \(otherLocalizableStringFile.path) has redundant keys.")
                            } else if developmentLocalizableKeys.count > otherLocalizableKeys.count {
                                XCTFail("Localized Strings File: \(otherLocalizableStringFile.path) has missing keys.")
                            }
                        } else {
                            XCTFail("Localized Strings File not found in Lang: \(otherLocalization.lang)")
                        }
                    }
                }
            } else {
                XCTFail("developmentLocalization not found in Bundle: \(bundle)")
            }
        }
    }

}

private extension L10NTestsTests {
    struct Localization: Equatable {
        struct LocalizableStringFile {
            struct Value {
                let key: String
                let value: String
            }
            
            let name: String
            let path: String
            var values: [Value] = []
        }
        
        let lang: String
        var localizableStringFiles: [LocalizableStringFile] = []
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.lang == rhs.lang
        }
    }
}
