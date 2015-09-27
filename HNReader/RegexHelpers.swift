//
//  RegexHelpers.swift
//  HNReader
//
//  Created by Javi Manzano on 27/09/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation

extension String {
    var html2String:String {
        do {
            let result = try NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
            return result
        } catch {
            print(error)
            return "Nope"
        }
    }
}
