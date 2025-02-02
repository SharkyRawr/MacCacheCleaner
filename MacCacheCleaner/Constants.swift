//
//  Constants.swift
//  Mac Cache Cleaner
//
//  Created by Kaunteya Suryawanshi on 12/07/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

extension URL {
    /// Fetches json which has details of all the cache definitions
    static let sourceJSONPath: URL = "https://github.com/SharkyRawr/MacCacheCleaner/raw/master/Source.json"

    /// Fetches info of `latest` maccachecleaner from github
    static let latestVersion: URL = "https://github.com/SharkyRawr/MacCacheCleaner/releases/latest"
}
