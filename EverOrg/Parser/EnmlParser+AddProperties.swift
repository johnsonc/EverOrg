//
//  EnmlParser+AddProperties.swift
//  EverOrg
//
//  Created by Mario Martelli on 07.02.17.
//  Copyright © 2017 Mario Martelli. All rights reserved.
//
//  This file is part of EverOrg.
//
//  Foobar is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  EverOrg is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with EverOrg.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

extension EnmlParser {

  func addMedia(_ attributes: Dictionary<String, String>) -> Bool {

    var hash: String?
    var type: String?
    var height: Int?
    var width: Int?
    var alt: String?

    for (rawkey, strValue) in attributes {
      switch rawkey {
      case "hash":
        hash = strValue
      case "type":
        type = strValue
      case "height":
        height = Int(strValue)
      case "width":
        width = Int(strValue)
      case "alt":
        alt = strValue
      default:
        // align, alt, longdesc, border, hspace, vspace, usemap
        // do not have any correspondent attribute in Org mode
        // at the moment
        // print("unprocessed key \(rawkey) with value \(strValue)")
        break
      }
    }


    let tagClass = kUTTagClassMIMEType
    if let mediaHash = hash, let mType = type,
      let mediaType = UTTypeCreatePreferredIdentifierForTag(tagClass, mType as CFString, nil)?.takeRetainedValue() {

      if UTTypeConformsTo(mediaType, kUTTypeImage) {
        width = width != nil ? width : 0
        height = height != nil ? height : 0
        let image = Image(type: mType, hash: mediaHash, width: width!, heigth: height!, alt: alt)
        addContent(element: image)
      } else {
        let attachment = Attachment(type: mType, hash: mediaHash)
        addContent(element: attachment)
      }
      return true
    } else {
      print("media not processed: \(type)")
      return false
    }
  }

  func addContent(element: Element) {
    if fieldContent != nil {
      fieldContent?.append(element)
    } else {
      content.append(element)
    }
  }
}
