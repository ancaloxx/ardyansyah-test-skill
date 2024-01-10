//
//  Data+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 07/01/24.
//

import Foundation
import SwiftUI

enum ImageFormat: String, CaseIterable {
    case png
    case jpeg
    case gif
    case unknown
    
    init(byte: UInt8) {
        switch byte {
        case 0x89:
            self = .png
        case 0xFF:
            self = .jpeg
        case 0x47:
            self = .gif
        default:
            self = .unknown
        }
    }
    
    var mimeType: String? {
        switch self {
        case .unknown:
            return nil
        default:
            return "image/" + rawValue // Avoid using \()
        }
    }
}

extension Data {
    var imageFormat: ImageFormat {
        guard let header = map({ $0 as UInt8 })[0] as? UInt8 else {
            return .unknown
        }
        
        return ImageFormat(byte: header)
    }
    
    var imageBase64URIOutputString: String? {
        guard let mimeType = imageFormat.mimeType else {
            return nil
        }
    
        return "data:\(mimeType);base64,\(base64EncodedString())"
    }
}
