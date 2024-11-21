//
//  Encodable+.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/22/24.
//

import Foundation

extension Encodable {

    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Dictionary 변환 실패"))
        }
        return dictionary
    }

}
